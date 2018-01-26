#!/usr/bin/env bash
set -euo pipefail

# All rust-related downloads can be found at
# https://static.rust-lang.org/dist/index.html.  To find the date on
# which a particular thing was last updated, look for the *-date.txt
# file, e.g.
# https://static.rust-lang.org/dist/channel-rust-beta-date.txt

PLATFORMS=(
  i686-unknown-linux-gnu
  x86_64-unknown-linux-gnu
  armv7-unknown-linux-gnueabihf
  aarch64-unknown-linux-gnu
  i686-apple-darwin
  x86_64-apple-darwin
)
BASEURL=https://static.rust-lang.org/dist
VERSION=${1:-}
DATE=${2:-}

if [[ -z $VERSION ]]
then
    echo "No version supplied"
    exit -1
fi

if [[ -n $DATE ]]
then
    BASEURL=$BASEURL/$DATE
fi

for PLATFORM in "${PLATFORMS[@]}"
do
    URL="$BASEURL/rust-$VERSION-$PLATFORM.tar.gz.sha256"
    SHA256=$(curl -sSfL $URL | cut -d ' ' -f 1)
    echo "$PLATFORM = \"$SHA256\";"
done
