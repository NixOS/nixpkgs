#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq git nix-prefetch-git common-updater-scripts gnused

set -euo pipefail

OWNER="wez"
REPO="wezterm"

NIXPKGS_ROOT=$(git rev-parse --show-toplevel)
PACKAGE_NIX_ATTR_PATH="wezterm"

# For wezterm, the version is 0-unstable-YYYY-MM-DD, so we need to get the commit date
# from the latest commit, not the release tag.
# We also need the latest commit SHA for the rev.

LATEST_COMMIT_INFO=$(curl ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} --location --silent "https://api.github.com/repos/$OWNER/$REPO/commits/HEAD")
LATEST_REV=$(echo "$LATEST_COMMIT_INFO" | jq --raw-output '.sha')
COMMIT_DATE=$(echo "$LATEST_COMMIT_INFO" | jq --raw-output '.commit.author.date' | cut -d 'T' -f 1)

NEW_VERSION="0-unstable-$COMMIT_DATE"

FETCH_JSON=$(nix-prefetch-git --url "https://github.com/$OWNER/$REPO" --rev "$LATEST_REV" --fetch-submodules)
FETCH_HASH=$(echo "$FETCH_JSON" | jq --raw-output .hash)

(cd "$NIXPKGS_ROOT" && update-source-version "$PACKAGE_NIX_ATTR_PATH" "$NEW_VERSION" "$FETCH_HASH" --rev="$LATEST_REV")

sed -i -e "s#hash = \"sha256-.*\"#hash = \"$FETCH_HASH\"#" "$NIXPKGS_ROOT/pkgs/by-name/we/wezterm/package.nix"

CARGO_LOCK_PATH="$(echo "$FETCH_JSON" | jq --raw-output .path)/Cargo.lock"

CARGO_HASH=$(nix-hash --to-sri --type sha256 "$(nix-hash --type sha256 --base32 "$CARGO_LOCK_PATH")")

sed -i -e "s#cargoHash = \"sha256-.*\"#cargoHash = \"$CARGO_HASH\"#" "$NIXPKGS_ROOT/pkgs/by-name/we/wezterm/package.nix"

echo "Wezterm update script finished."
