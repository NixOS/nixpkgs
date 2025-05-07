#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq nix bash coreutils nix-update common-updater-scripts ripgrep flutter

set -eou pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

cd "${SCRIPT_DIRECTORY}"/..
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
TMPDIR="$(mktemp -d)"
cp --recursive --no-preserve=mode "$src"/* $TMPDIR
cd "$TMPDIR"/flutter/wind_send
flutter pub get
yq . pubspec.lock >"${SCRIPT_DIRECTORY}"/pubspec.lock.json
rm -rf $TMPDIR
