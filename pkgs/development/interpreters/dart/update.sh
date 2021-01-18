#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

CHANNELS=(stable beta dev)
declare -A PLATFORMS=(
    [macos-x64]=x86_64-darwin
    [linux-ia32]=i686-linux
    [linux-x64]=x86_64-linux
    [linux-arm]=armv7l-linux
    [linux-arm64]=aarch64-linux
)
BASE="https://storage.googleapis.com/dart-archive/channels"

TMP=sources.tmp.json
echo '' > $TMP

for channel in ${CHANNELS[@]}; do
  version=$(curl "${BASE}/${channel}/release/latest/VERSION" | jq -r '.version')
  for platform in "${!PLATFORMS[@]}"; do
    url="${BASE}/${channel}/release/${version}/sdk/dartsdk-${platform}-release.zip"
    sha256=$(nix-prefetch-url "$url")
    nixPlatform=${PLATFORMS[$platform]}
    jq --arg channel $channel \
       --arg version $version \
       --arg platform $nixPlatform \
       --arg url "$url" \
       --arg sha256 $sha256 \
       -n '$ARGS.named' >> $TMP
  done
done

jq -s '.' $TMP > sources.json
rm $TMP
