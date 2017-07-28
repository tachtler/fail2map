#!/bin/bash
set -f 

##############################################################################
# Script-Name : fail2map-merge.sh                                            # 
# Description : Merge various places.geojson file to one.                    # 
#                                                                            # 
#                                                                            # 
#                                                                            # 
#                                                                            # 
#                                                                            # 
# Last update : 25.11.2016                                                   # 
# Version     : 1.00                                                         # 
#                                                                            #
# Author      : Klaus Tachtler, <klaus@tachtler.net>                         #
# DokuWiki    : http://www.dokuwiki.tachtler.net                             #
# Homepage    : http://www.tachtler.net                                      #
#                                                                            #
#  +----------------------------------------------------------------------+  #
#  | This program is free software; you can redistribute it and/or modify |  #
#  | it under the terms of the GNU General Public License as published by |  #
#  | the Free Software Foundation; either version 2 of the License, or    |  #
#  | (at your option) any later version.                                  |  #
#  +----------------------------------------------------------------------+  #
#                                                                            #
# Copyright (c) 2016 by Klaus Tachtler.                                      #
#                                                                            #
#############################################################################

##############################################################################
#                                H I S T O R Y                               # 
##############################################################################
# Version     : x.xx                                                         # 
# Description : <Description>                                                #
# -------------------------------------------------------------------------- # 
# Version     : x.xx                                                         # 
# Description : <Description>                                                #
# -------------------------------------------------------------------------- # 
##############################################################################

# Source function library.
. /etc/init.d/functions

# Variable declarations.

##############################################################################
# >>> Please edit following lines for personal command and/or configuration! #
##############################################################################

# CUSTOM - Script-Name.
SCRIPT_NAME='fail2map-merge.sh'

# CUSTOM - PATH/FILE/PARAMETER variables.
FAIL2MAP_FILE_MERGED="/var/www/fail2map/places.geojson"
FAIL2MAP_FILE_LIST="/var/www/fail2map/server1/file1.places.geojson,/var/www/fail2map/server2/file2.places.geojson,/var/www/fail2map/server3/file3.places.geojson"

# CUSTOM - Mail-Recipient.
MAIL_RECIPIENT='you@example.com'

# CUSTOM - Status-Mail [Y|N].
MAIL_STATUS='N'

##############################################################################
# >>> Normaly there is no need to change anything below this comment line. ! #
##############################################################################

# Variables.
TOUCH_COMMAND=`command -v touch`
RM_COMMAND=`command -v rm`
CAT_COMMAND=`command -v cat`
DATE_COMMAND=`command -v date`
PROG_SENDMAIL=`command -v sendmail`
TAIL_COMMAND=`command -v tail`
HEAD_COMMAND=`command -v head`
SED_COMMAND=`command -v sed`
FILE_LOCK='/tmp/'$SCRIPT_NAME'.lock'
FILE_LOG='/var/log/'$SCRIPT_NAME'.log'
FILE_LAST_LOG='/tmp/'$SCRIPT_NAME'.log'
FILE_MAIL='/tmp/'$SCRIPT_NAME'.mail'
VAR_HOSTNAME=`uname -n`
VAR_SENDER='root@'$VAR_HOSTNAME
VAR_EMAILDATE=`$DATE_COMMAND '+%a, %d %b %Y %H:%M:%S (%Z)'`

# Functions.
function log() {
        echo $1
        echo `$DATE_COMMAND '+%Y/%m/%d %H:%M:%S'` " INFO:" $1 >>${FILE_LAST_LOG}
}

function retval() {
if [ "$?" != "0" ]; then
        case "$?" in
        *)
                log "ERROR: Unknown error $?"
        ;;
        esac
fi
}

function movelog() {
        $CAT_COMMAND $FILE_LAST_LOG >> $FILE_LOG
        $RM_COMMAND -f $FILE_LAST_LOG
        $RM_COMMAND -f $FILE_LOCK
}

function sendmail() {
        case "$1" in
        'STATUS')
                MAIL_SUBJECT='Status execution '$SCRIPT_NAME' script.'
        ;;
        *)
                MAIL_SUBJECT='ERROR while execution '$SCRIPT_NAME' script !!!'
        ;;
        esac

$CAT_COMMAND <<MAIL >$FILE_MAIL
Subject: $MAIL_SUBJECT
Date: $VAR_EMAILDATE
From: $VAR_SENDER
To: $MAIL_RECIPIENT

MAIL

$CAT_COMMAND $FILE_LAST_LOG >> $FILE_MAIL

$PROG_SENDMAIL -f $VAR_SENDER -t $MAIL_RECIPIENT < $FILE_MAIL

$RM_COMMAND -f $FILE_MAIL

}

# Main.
log ""
log "+-----------------------------------------------------------------+"
log "| Start copying the fail2map places.geojson file to the fail2map. |"
log "+-----------------------------------------------------------------+"
log ""
log "Run script with following parameter:"
log ""
log "SCRIPT_NAME...........: $SCRIPT_NAME"
log ""
log "FAIL2MAP_FILE_MERGED..: $FAIL2MAP_FILE_MERGED"
log "FAIL2MAP_FILE_LIST....: $FAIL2MAP_FILE_LIST"
log ""
log "MAIL_RECIPIENT........: $MAIL_RECIPIENT"
log "MAIL_STATUS...........: $MAIL_STATUS"
log ""

# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$TOUCH_COMMAND" ]; then
        log "Check if command '$TOUCH_COMMAND' was found....................[FAILED]"
        sendmail ERROR
        movelog
        exit 10
else
        log "Check if command '$TOUCH_COMMAND' was found....................[  OK  ]"
fi

# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$RM_COMMAND" ]; then
        log "Check if command '$RM_COMMAND' was found.......................[FAILED]"
        sendmail ERROR
        movelog
        exit 11
else
        log "Check if command '$RM_COMMAND' was found.......................[  OK  ]"
fi

# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$CAT_COMMAND" ]; then
        log "Check if command '$CAT_COMMAND' was found......................[FAILED]"
        sendmail ERROR
        movelog
        exit 12
else
        log "Check if command '$CAT_COMMAND' was found......................[  OK  ]"
fi

# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$DATE_COMMAND" ]; then
        log "Check if command '$DATE_COMMAND' was found.....................[FAILED]"
        sendmail ERROR
        movelog
        exit 13
else
        log "Check if command '$DATE_COMMAND' was found.....................[  OK  ]"
fi

# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$PROG_SENDMAIL" ]; then
        log "Check if command '$PROG_SENDMAIL' was found................[FAILED]"
        sendmail ERROR
        movelog
        exit 14
else
        log "Check if command '$PROG_SENDMAIL' was found................[  OK  ]"
fi

# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$TAIL_COMMAND" ]; then
        log "Check if command '$TAIL_COMMAND' was found.....................[FAILED]"
        sendmail ERROR
        movelog
        exit 15
else
        log "Check if command '$TAIL_COMMAND' was found.....................[  OK  ]"
fi


# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$HEAD_COMMAND" ]; then
        log "Check if command '$HEAD_COMMAND' was found.....................[FAILED]"
        sendmail ERROR
        movelog
        exit 16
else
        log "Check if command '$HEAD_COMMAND' was found.....................[  OK  ]"
fi

# Check if command (file) NOT exist OR IS empty.
if [ ! -s "$SED_COMMAND" ]; then
        log "Check if command '$SED_COMMAND' was found......................[FAILED]"
        sendmail ERROR
        movelog
        exit 17
else
        log "Check if command '$SED_COMMAND' was found......................[  OK  ]"
fi

# Check if LOCK file NOT exist.
if [ ! -e "$FILE_LOCK" ]; then
        log "Check if script is NOT already runnig .....................[  OK  ]"

        $TOUCH_COMMAND $FILE_LOCK
else
        log "Check if script is NOT already runnig .....................[FAILED]"
        log ""
        log "ERROR: The script was already running, or LOCK file already exists!"
        log ""
        sendmail ERROR
        movelog
        exit 20
fi

# Start update.
log ""
log "+-----------------------------------------------------------------+"
log "| Run execute of $SCRIPT_NAME ............................. |"
log "+-----------------------------------------------------------------+"
log ""

if [ -f $FAIL2MAP_FILE_MERGED ] ; then

    	$RM_COMMAND $FAIL2MAP_FILE_MERGED

	if [ "$?" != 0 ]; then
        	retval $?
        	log "Delete '$FAIL2MAP_FILE_MERGED' .................[FAILED]"
        	$RM_COMMAND -f $FILE_LOCK
        	sendmail ERROR
        	movelog
        	exit 50
	else
        	log "Delete '$FAIL2MAP_FILE_MERGED' .................[  OK  ]"
	fi
else
        log "Delete '$FAIL2MAP_FILE_MERGED' .................[NOTFND]"

fi

# Determine files.
array=(${FAIL2MAP_FILE_LIST//,/ })

# Add HEADER
$CAT_COMMAND <<FAIL2BANFILEMERGEHEADER >$FAIL2MAP_FILE_MERGED
{
    "features": [
FAIL2BANFILEMERGEHEADER

for i in "${!array[@]}"
do

	if [ -s "${array[i]}" ] 
	then

    		$TAIL_COMMAND -n +3 ${array[i]} | $HEAD_COMMAND -n -4 >>$FAIL2MAP_FILE_MERGED

$CAT_COMMAND <<FAIL2BANFILEMERGESEPARATOR >>$FAIL2MAP_FILE_MERGED
        },
FAIL2BANFILEMERGESEPARATOR
	fi

done

# Delete last }, separator
$SED_COMMAND -i '$ d' $FAIL2MAP_FILE_MERGED

# Add FOOTER
$CAT_COMMAND <<FAIL2BANFILEMERGEFOOTER >>$FAIL2MAP_FILE_MERGED
        }
     ],
    "type": "FeatureCollection"
}
FAIL2BANFILEMERGEFOOTER

log ""
log "Create '$FAIL2MAP_FILE_MERGED' .................[  OK  ]"

# Finish execute.
log ""
log "+-----------------------------------------------------------------+"
log "| End execute of $SCRIPT_NAME ............................. |"
log "+-----------------------------------------------------------------+"
log ""

# Status e-mail.
if [ $MAIL_STATUS = 'Y' ]; then
        sendmail STATUS
fi
# Move temporary log to permanent log
movelog

exit 0
