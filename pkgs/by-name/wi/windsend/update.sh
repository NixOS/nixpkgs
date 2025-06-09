#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq nix bash coreutils nix-update common-updater-scripts ripgrep flutter

set -eou pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR"/..
while ! test -f flake.nix; do cd ..; done
NIXPKGS_DIR="$PWD"

latestVersion=$(
    list-git-tags --url=https://github.com/doraemonkeys/WindSend |
        rg '^v(.*)' -r '$1' |
        sort --version-sort |
        tail -n1
)

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; windsend.version or (lib.getVersion windsend)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --version=$latestVersion windsend

export HOME="$(mktemp -d)"
src="$(nix-build --no-link "$NIXPKGS_DIR" -A windsend.src)"
tmp="$(mktemp -d)"
cp --recursive --no-preserve=mode "$src"/* $tmp
pushd "$tmp"/flutter/wind_send
flutter pub get
yq . pubspec.lock >"$PACKAGE_DIR"/pubspec.lock.json
popd
rm -rf $tmp
