#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gawk common-updater-scripts coreutils jq squashfs-tools

set -eu -o pipefail

RELEASES=$(curl -H 'Snap-Device-Series: 16' http://api.snapcraft.io/v2/snaps/info/chromium-ffmpeg)
# We only need the download url and architecture
STABLE_RELEASES=$(echo $RELEASES | jq '.["channel-map"] | .[] |  select(.channel.risk=="stable") | { arch: .channel.architecture, url: .download.url }')

function get_url() {
  local architecture=$1
  echo $STABLE_RELEASES | jq -r '. | select(.arch=="'${architecture}'") | .url'
}

# TODO If nix ever supports sha3-384, we can get that from the JSON and use it for the download hash
function get_source() {
  local url=$1
  # returns the source path
  nix-prefetch-url --print-path "$url" | tail -n 1
}

function max_version() {
  local source=$1
  local versions="$(unsquashfs -l $source | grep -Po '^squashfs-root/chromium-ffmpeg-git-\K[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')"
  echo "$versions" | sort -V | tail -n 1
}

function update_source() {
  local platform=$1
  local url=$2
  local source=$3
  local version=$4
  local source_hash=$(nix-hash --type sha256 --flat --base32 "$source")
  local hash=$(nix-hash --to-sri --type sha256 "$source_hash")
  update-source-version "vivaldi-ffmpeg-codecs" "$version" "$hash" "$url" --ignore-same-version --system=$platform --source-key="sources.$platform"
}

x86_url="$(get_url "amd64")"
x86_source="$(get_source ${x86_url})"
x86_version="0-unstable-$(max_version ${x86_source})"

arm64_url="$(get_url "arm64")"
arm64_source="$(get_source ${arm64_url})"
arm64_version="0-unstable-$(max_version ${arm64_source})"

currentVersion=$(nix eval --raw -f . vivaldi-ffmpeg-codecs.version)

if [[ "$currentVersion" == "$x86_version" ]]; then
  exit 0
fi

# If this fails too often, we can try using the lesser of the two versions for both
# as the snap contains the last 4-5 versions.
if [[ "$x86_version" != "$arm64_version" ]]; then
  >&2 echo "Multiple chromium versions found: $x86_version (intel) and $arm64_version (arm); no update"
  exit 1
fi

update_source "x86_64-linux" "$x86_url" "$x86_source" "$x86_version"
update_source "aarch64-linux" "$arm64_url" "$arm64_source" "$arm64_version"
