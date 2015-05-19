#####################################################################################################################
## This script was developed by Guberni and is part of Tellki monitoring solution                     		       ##
##                                                                                                      	       ##
## December, 2014                     	                                                                	       ##
##                                                                                                      	       ##
## Version 1.0                                                                                          	       ##
##																									    	       ##
## DESCRIPTION: Monitor network interface traffic, errors, collisions and discards								   ##
##																											       ##
## SYNTAX: ./NET_Linux.sh <METRIC_STATE>             														       ##
##																											       ##
## EXAMPLE: ./NET_Linux.sh "1,1,1,1,1,1,0"         														           ##
##																											 	   ##
##                                      ############                                                    	 	   ##
##                                      ## README ##                                                    	 	   ##
##                                      ############                                                    	 	   ##
##																											 	   ##
## This script is used combined with runremote.sh script, but you can use as standalone. 			    	 	   ##
##																											 	   ##
## runremote.sh - executes input script locally or at a remove server, depending on the LOCAL parameter.	 	   ##
##																											 	   ##
## SYNTAX: sh "runremote.sh" <HOST> <METRIC_STATE> <USER_NAME> <PASS_WORD> <TEMP_DIR> <SSH_KEY> <LOCAL> 	 	   ##
##																											       ##
## EXAMPLE: (LOCAL)  sh "runremote.sh" "NET_Linux.sh" "192.168.1.1" "1,1,1,1,1,1,1" "" "" "" "" "1"                ##
## 			(REMOTE) sh "runremote.sh" "NET_Linux.sh" "192.168.1.1" "1,1,1,1,1,0,0" "user" "pass" "/tmp" "null" "0"##
##																											 	   ##
## HOST - hostname or ip address where script will be executed.                                         	 	   ##
## METRIC_STATE - is generated internally by Tellki and its only used by Tellki default monitors.       	 	   ##
##         		  1 - metric is on ; 0 - metric is off					              						 	   ##
## USER_NAME - user name required to connect to remote host. Empty ("") for local monitoring.           	 	   ##
## PASS_WORD - password required to connect to remote host. Empty ("") for local monitoring.            	 	   ##
## TEMP_DIR - (remote monitoring only): directory on remote host to copy scripts before being executed.		 	   ##
## SSH_KEY - private ssh key to connect to remote host. Empty ("null") if password is used.                 	   ##
## LOCAL - 1: local monitoring / 0: remote monitoring                                                   	 	   ##
#####################################################################################################################

#METRIC_ID
inID="223:Network traffic in:4"
outID="224:Network traffic out:4"
inErrorsID="98:In Errors:4"
outErrorsID="23:Out Errors:4"
collisionsID="107:Network Collisions:4"
inDropID="195:In Dropped Packages:4"
outDropID="147:Out Dropped Packages:4"

#INPUTS
inID_on=`echo $1 | awk -F',' '{print $1}'`
outID_on=`echo $1 | awk -F',' '{print $2}'`
inErrorsID_on=`echo $1 | awk -F',' '{print $3}'`
outErrorsID_on=`echo $1 | awk -F',' '{print $4}'`
collisionsID_on=`echo $1 | awk -F',' '{print $5}'`
inDropID_on=`echo $1 | awk -F',' '{print $6}'`
outDropID_on=`echo $1 | awk -F',' '{print $7}'`


for face in `cat /proc/net/dev | grep ':'| awk -F':' '{print $1}' | grep -v "lo"`
do

        if [ $inID_on -eq 1 ]
        then
		inMB=`cat /proc/net/dev | grep $face | awk '{print int(($2/1024)/1024)}'`
                if [ "$inMB" = "" ]
				then
					#Unable to collect metrics
					exit 8 
				fi
        fi

        if [ $outID_on -eq 1 ]
        then
		outMB=`cat /proc/net/dev | grep $face | awk '{print int(($(NF-7)/1024)/1024)}'`
                if [ "$outMB" = "" ]
				then
					#Unable to collect metrics
					exit 8 
				fi
        fi

        if [ $inErrorsID_on -eq 1 ]
        then
		inError=`cat /proc/net/dev | grep $face | awk '{print $4}'`
                if [ "$inError" = "" ]
				then
					#Unable to collect metrics
					exit 8 
				fi
        fi
		
		if [ $outErrorsID_on -eq 1 ]
        then
		outError=`cat /proc/net/dev | grep $face | awk '{print $(NF-5)}'`
                if [ "$outError" = "" ]
				then
					#Unable to collect metrics
					exit 8 
				fi
        fi
		
	if [ $collisionsID_on -eq 1 ]
        then
		collision=`cat /proc/net/dev | grep $face | awk '{print $(NF-2)}'`
                if [ "$collision" = "" ]
				then
					#Unable to collect metrics
					exit 8 
				fi
        fi
	if [ $inDropID_on -eq 1 ]
        then
		inDrop=`cat /proc/net/dev | grep $face | awk '{print $5}'`
                if [ "$inDrop" = "" ]
				then
					#Unable to collect metrics
					exit 8 
				fi
        fi
	if [ $outDropID_on -eq 1 ]
        then
		outDrop=`cat /proc/net/dev | grep $face | awk '{print $(NF-4)}'`
                if [ "$outDrop" = "" ]
				then
					#Unable to collect metrics
					exit 8 
				fi
        fi

# Send Metrics
if [ $inID_on -eq 1 ]
then
	echo "$inID|$inMB|$face|"
fi
if [ $outID_on -eq 1 ]
then
	echo "$outID|$outMB|$face|"
fi
if [ $inErrorsID_on -eq 1 ]
then
	echo "$inErrorsID|$inError|$face|"
fi
if [ $outErrorsID_on -eq 1 ]
then
	echo "$outErrorsID|$outError|$face|"
fi
if [ $collisionsID_on -eq 1 ]
then
	echo "$collisionsID|$collision|$face|"
fi
if [ $inDropID_on -eq 1 ]
then
	echo "$inDropID|$inDrop|$face|"
fi
if [ $outDropID_on -eq 1 ]
then
	echo "$outDropID|$outDrop|$face|"
fi

done
