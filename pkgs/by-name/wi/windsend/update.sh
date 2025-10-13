#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq nix bash coreutils nix-update common-updater-scripts ripgrep flutter

set -euo pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestVersion=$(
    list-git-tags --url=https://github.com/doraemonkeys/WindSend |
        rg '^v(.*)' -r '$1' |
        sort --version-sort |
        tail -n1
)

currentVersion=$(nix eval --raw --file . windsend.version)

[[ $currentVersion == $latestVersion ]] && {
    echo "package is up-to-date: $currentVersion"
    exit 0
}

nix-update --version=$latestVersion windsend

src=$(nix build --no-link --print-out-paths .#windsend.src)
source=$(mktemp -d)
cp -r --no-preserve=mode "$src/"* "$source"
pushd "$source/flutter/wind_send"
flutter pub get
yq . pubspec.lock >"$PACKAGE_DIR/pubspec.lock.json"
popd
rm -rf "$source"
./update-gitHashes.py
