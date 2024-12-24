#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -gt 2 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the zammad packages."
  echo "Usage: $0 [package name] [zammad directory in nixpkgs]"
  exit 1
fi

VERSION=$(xidel -s https://ftp.zammad.com/ --extract "//a" | grep -E "zammad-[0-9.]*.tar.gz" | sort --version-sort | tail -n 1 | sed -e 's/zammad-//' -e 's/.tar.gz//')
TARGET_DIR="$2"
WORK_DIR=$(mktemp -d)
SOURCE_DIR=$WORK_DIR/zammad-$VERSION

pushd $TARGET_DIR

rm -rf \
    ./source.json \
    ./gemset.nix \
    ./yarn.lock \
    ./yarn.nix


# Check that working directory was created.
if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
    echo "Could not create temporary directory."
    exit 1
fi

# Delete the working directory on exit.
function cleanup {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT


pushd $WORK_DIR

echo ":: Creating source.json"
nix-prefetch-github zammad zammad --rev $VERSION --json --fetch-submodules | jq 'del(.leaveDotGit) | del(.deepClone)' > $TARGET_DIR/source.json
echo >> $TARGET_DIR/source.json

echo ":: Fetching source"
curl -L https://github.com/zammad/zammad/archive/$VERSION.tar.gz --output source.tar.gz
tar zxf source.tar.gz

if [[ ! "$SOURCE_DIR" || ! -d "$SOURCE_DIR" ]]; then
    echo "Source directory does not exists."
    exit 1
fi

pushd $SOURCE_DIR

echo ":: Creating gemset.nix"
bundix --lockfile=./Gemfile.lock  --gemfile=./Gemfile --gemset=$TARGET_DIR/gemset.nix

popd
popd
popd
