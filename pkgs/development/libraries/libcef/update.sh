#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq

set -x -eu -o pipefail

cd $(dirname "${BASH_SOURCE[0]}")

VERSION_JSON=$(curl --silent https://cef-builds.spotifycdn.com/index.json | jq '[.linux64.versions[] | select (.channel == "stable")][0]')

CEF_VERSION=$(echo ${VERSION_JSON} | jq -r '.cef_version' | cut -d'+' -f1)
GIT_REVISION=$(echo ${VERSION_JSON} | jq -r '.cef_version' | cut -d'+' -f2 | cut -c 2-)
CHROMIUM_VERSION=$(echo ${VERSION_JSON} | jq -r '.chromium_version')

SHA256_LINUX64=$(nix-prefetch-url --quiet https://cef-builds.spotifycdn.com/cef_binary_${CEF_VERSION}+g${GIT_REVISION}+chromium-${CHROMIUM_VERSION}_linux64_minimal.tar.bz2)
SHA256_LINUXARM64=$(nix-prefetch-url --quiet https://cef-builds.spotifycdn.com/cef_binary_${CEF_VERSION}+g${GIT_REVISION}+chromium-${CHROMIUM_VERSION}_linuxarm64_minimal.tar.bz2)

setKV () {
    sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" ./default.nix
}

setKV version ${CEF_VERSION}
setKV gitRevision ${GIT_REVISION}
setKV chromiumVersion ${CHROMIUM_VERSION}
setKV 'platforms."aarch64-linux".sha256' ${SHA256_LINUXARM64}
setKV 'platforms."x86_64-linux".sha256' ${SHA256_LINUX64}
