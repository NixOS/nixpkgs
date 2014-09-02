#!/bin/sh

# this shows a list of available xmls
android list sdk | grep 'Parse XML:' | cut -f8- -d\  # | xargs -n 1 curl -O

# we skip the intel addons, as they are Windows+osX only
# we skip the default sys-img (arm?) because it is empty
curl -o repository-10.xml https://dl-ssl.google.com/android/repository/repository-10.xml
curl -o addon.xml        https://dl-ssl.google.com/android/repository/addon.xml
curl -o sys-img.xml https://dl-ssl.google.com/android/repository/sys-img/android/sys-img.xml

./generate-addons.sh
./generate-platforms.sh
./generate-sysimages.sh
