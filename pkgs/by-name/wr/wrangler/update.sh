#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../ -i bash -p curl jq nurl prefetch-npm-deps nodejs
set -xeou pipefail

LATEST_RELEASE=$(curl "https://api.github.com/repos/cloudflare/workers-sdk/releases" | jq -r '.[0]')

TAG_NAME=$(echo "$LATEST_RELEASE"| jq -r '.tag_name')
sed -E 's#\brev = ".*?"#rev = "'"$TAG_NAME"'"#' -i package.nix

SRC_HASH=$(nurl "https://github.com/cloudflare/workers-sdk" "$TAG_NAME" --hash)
sed -E 's#\bhash = ".*?"#hash = "'"$SRC_HASH"'"#' -i package.nix

TEMP_DIR=$(mktemp -d)
pushd "$TEMP_DIR"
curl "https://raw.githubusercontent.com/cloudflare/workers-sdk/$TAG_NAME/package.json" -o package.json
npm install --package-lock-only
NPM_DEPS_HASH=$(prefetch-npm-deps ./package-lock.json)
popd
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$NPM_DEPS_HASH"'"#' -i package.nix
cp "$TEMP_DIR/package-lock.json" package-lock.json
