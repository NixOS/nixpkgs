#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts jq

set -x -e -o pipefail

module_list=( \
    qt3d \
    qtactiveqt \
    qtandroidextras \
    qtbase \
    qtcharts \
    qtconnectivity \
    qtdatavis3d \
    qtdeclarative \
    qtdoc \
    qtgamepad \
    qtgraphicaleffects \
    qtimageformats \
    qtlocation \
    qtlottie \
    qtmacextras \
    qtmultimedia \
    qtnetworkauth \
    qtpurchasing \
    qtquick3d \
    qtquickcontrols \
    qtquickcontrols2 \
    qtquicktimeline \
    qtremoteobjects \
    qtscript \
    qtscxml \
    qtsensors \
    qtserialbus \
    qtserialport \
    qtspeech \
    qtsvg \
    qttools \
    qttranslations \
    qtvirtualkeyboard \
    qtwayland \
    qtwebchannel \
    qtwebglplugin \
    qtwebsockets \
    qtwebview \
    qtwinextras \
    qtx11extras \
    qtxmlpatterns \
    )

srcs="$(dirname "${BASH_SOURCE[0]}")/srcs"
mkdir -p "$srcs"

for module in "${module_list[@]}"
do
    url="https://invent.kde.org/qt/qt/${module}.git"
    nix-prefetch-git --url $url --rev refs/heads/kde/5.15 \
        | jq '{url,rev,sha256,fetchLFS,fetchSubmodules,deepClone,leaveDotGit}' \
        > "${srcs}/${module}.json"
done
