#!/bin/sh
# Client simulation for VOD  HLS player
# This script will access the m3u8 file and go through each and every
# chunks listed in the manifest and fetches that.
# No command line optioss available, modify everything inside the program

# The m3u8 URL
M3U8_URL=https://ec2-54-179-176-27.ap-southeast-1.compute.amazonaws.com/vod_https.m3u8

# Iterations- How many times we need to repeat the process
ITERATIONS=10

# How much time we need to sleep between accessign the chunks
DEF_SLEEP_TIME=5

# User agent string
USER_AGENT=MyPlayer

COUNTER=0

while [ $COUNTER -lt $ITERATIONS ]; do

    # Get the m3u8 using the https
    curl --remote-name -k  $M3U8_URL


    for line in `cat vod_https.m3u8` ; do

        if [[ $line == *"ts" ]] ; then
            echo "Accessing $line "
            curl --remote-name $line
            sleep $DEF_SLEEP_TIME
        elif [[ $line == *"EXT-X-ENDLIST" ]]; then
            echo "END .. $line"
            break;
        fi

    done

    let COUNTER=$COUNTER+1

    # Clean up the space
    rm -f *.m3u8
    rm -f *.ts

done
