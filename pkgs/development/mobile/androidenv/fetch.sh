#! /usr/bin/env nix-shell
#! nix-shell -i bash --pure -p curl libxslt

# we skip the intel addons, as they are Windows+osX only
# we skip the default sys-img (arm?) because it is empty
curl -o repository-11.xml https://dl.google.com/android/repository/repository-11.xml
curl -o addon.xml         https://dl.google.com/android/repository/addon.xml
curl -o sys-img.xml       https://dl.google.com/android/repository/sys-img/android/sys-img.xml

./generate-addons.sh
./generate-platforms.sh
./generate-sysimages.sh
./generate-sources.sh
./generate-tools.sh
