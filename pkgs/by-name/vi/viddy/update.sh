#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq
# shellcheck shell=bash

# adapted from pkgs/by-name/ya/yazi-unwrapped/update.sh

set -eou pipefail

NIXPKGS_DIR="$PWD"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Get latest release
VIDDY_RELEASE=$(
    curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        https://api.github.com/repos/sachaos/viddy/releases/latest
)

# Get release information
latestBuildDate=$(echo "$VIDDY_RELEASE" | jq -r ".published_at")
latestVersion=$(echo "$VIDDY_RELEASE" | jq -r ".tag_name")

latestBuildDate="${latestBuildDate%T*}" # remove the timestamp and get the date
latestVersion="${latestVersion:1}"      # remove first char 'v'

oldVersion=$(nix eval --raw -f "$NIXPKGS_DIR" viddy.version)

if [[ "$oldVersion" == "$latestVersion" ]]; then
    echo "viddy is up-to-date: ${oldVersion}"
    exit 0
fi

echo "Updating viddy $oldVersion -> $latestVersion"

# nix-prefetch broken due to ninja finalAttrs.src.rev
nix-update viddy --version "$latestVersion"

# Build date
sed -i 's#env.VERGEN_BUILD_DATE = "[^"]*"#env.VERGEN_BUILD_DATE = "'"${latestBuildDate}"'"#' "$SCRIPT_DIR/package.nix"


