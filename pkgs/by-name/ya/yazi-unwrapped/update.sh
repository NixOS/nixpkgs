#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq common-updater-scripts gawk

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

echo "Updating code sources"

update-source-version yazi-unwrapped "${latestVersion}" --source-key=passthru.srcs.code_src

pushd "$SCRIPT_DIR"
echo "Updating build date"

sed -i 's#env.VERGEN_BUILD_DATE = "[^"]*"#env.VERGEN_BUILD_DATE = "'"${latestBuildDate}"'"#' package.nix

echo "Updating cargoHash"

# Set cargoHash to an empty string
sed -i -E 's/cargoHash = ".*?"/cargoHash = ""/' package.nix

# Build and get new hash
cargoHash=$( (nix-build "$NIXPKGS_DIR" -A yazi-unwrapped 2>&1 || true) | awk '/got/{print $2}')

if [ "$cargoHash" == "" ]; then
    echo "Failed to get cargoHash, please update it manually"
    exit 0
fi

sed -i -E 's/cargoHash = ".*?"/cargoHash = "'"$cargoHash"'"/' package.nix
popd
