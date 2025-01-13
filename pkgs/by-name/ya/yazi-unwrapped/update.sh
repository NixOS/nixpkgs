#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq common-updater-scripts nix-prefetch

set -eux

NIXPKGS_DIR="$PWD"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Get latest release
YAZI_RELEASE=$(
    curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        https://api.github.com/repos/sxyazi/yazi/releases/latest
)

# Get release information
latestBuildDate=$(echo "$YAZI_RELEASE" | jq -r ".published_at")
latestVersion=$(echo "$YAZI_RELEASE" | jq -r ".tag_name")

latestBuildDate="${latestBuildDate%T*}" # remove the timestamp and get the date
latestVersion="${latestVersion:1}"      # remove first char 'v'

oldVersion=$(nix eval --raw -f "$NIXPKGS_DIR" yazi-unwrapped.version)

if [[ "$oldVersion" == "$latestVersion" ]]; then
    echo "Yazi is up-to-date: ${oldVersion}"
    exit 0
fi

echo "Updating Yazi"

# Version
update-source-version yazi-unwrapped "${latestVersion}"

pushd "$SCRIPT_DIR"
# Build date
sed -i 's#env.VERGEN_BUILD_DATE = "[^"]*"#env.VERGEN_BUILD_DATE = "'"${latestBuildDate}"'"#' package.nix

# Hashes
cargoHash=$(nix-prefetch "{ sha256 }: (import $NIXPKGS_DIR {}).yazi-unwrapped.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed -i -E 's#\bcargoHash = ".*?"#cargoHash = "'"$cargoHash"'"#' package.nix
popd
