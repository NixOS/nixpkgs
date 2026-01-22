#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils gnugrep jq squashfsTools

set -eu -o pipefail

RELEASES=$(curl -H 'Snap-Device-Series: 16' http://api.snapcraft.io/v2/snaps/info/chromium-ffmpeg)
STABLE_RELEASES=$(echo $RELEASES | jq '."channel-map" | .[] | select(.channel.risk=="stable")')

function max_version() {
  local versions=$(echo $1 | jq -r '.version')
  echo "$(echo $versions |  grep -E -o '^[0-9]+')"
}

function update_source() {
  local platform=$1
  local selectedRelease=$2
  local version=$3
  local url=$(echo $selectedRelease | jq -r '.download.url')
  source="$(nix-prefetch-url "$url")"
  hash=$(nix-hash --to-sri --type sha256 "$source")
  update-source-version vivaldi-ffmpeg-codecs "$version" "$hash" "$url" --ignore-same-version --system=$platform --source-key="sources.$platform" --file "package.nix"
}

x86Release="$(echo $STABLE_RELEASES | jq 'select(.channel.architecture=="amd64")')"
x86CodecVersion=$(max_version "$x86Release")
arm64Release="$(echo $STABLE_RELEASES | jq -r 'select(.channel.architecture=="arm64")')"
arm64CodecVersion=$(max_version "$arm64Release")

currentVersion=$(grep 'version =' ./package.nix | cut -d '"' -f 2)

if [[ "$currentVersion" == "$x86CodecVersion" ]]; then
  exit 0
fi

# If this fails too often, consider finding the max common version between the two architectures
if [[ "$x86CodecVersion" != "$arm64CodecVersion" ]]; then
    >&2 echo "Multiple chromium versions found: $x86CodecVersion (intel) and $arm64CodecVersion (arm); no update"
    exit 1
fi



update_source "x86_64-linux" "$x86Release" "$x86CodecVersion"
update_source "aarch64-linux" "$arm64Release" "$arm64CodecVersion"
