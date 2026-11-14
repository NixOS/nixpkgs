#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnugrep gnused nix jq
# shellcheck shell=bash

set -eu -o pipefail

echo "Windmill UI builder: UPDATING"

# ASSUMES; The UI builder package is referenced in post-install script "untar_ui_builder.js"
# REF; https://github.com/windmill-labs/windmill/blob/205618af0a60b6bf5fcdd80f2b23c3b490ddbc00/frontend/scripts/untar_ui_builder.js#L23

WINDMILL_LATEST_VERSION=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --fail --location "https://api.github.com/repos/windmill-labs/windmill/releases/latest" | jq --raw-output .tag_name)
UI_BUILDER_SCRIPT=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --fail --location "https://github.com/windmill-labs/windmill/raw/$WINDMILL_LATEST_VERSION/frontend/scripts/untar_ui_builder.js")

PACKAGE_DIR=$(dirname "$(readlink --canonicalize-existing "${BASH_SOURCE[0]}")")
OUTPUT_FILE="$PACKAGE_DIR/ui_builder.nix"
NEW_URL=$(echo "$UI_BUILDER_SCRIPT" | sed --quiet --regexp-extended "s/.*tarUrl\s*=\s*'([^']+)['].*/\1/p")

TEMP_FILE="$OUTPUT_FILE.tmp"
cat > "$TEMP_FILE" <<EOF
# auto-generated file -- DO NOT EDIT!
{ fetchzip }:

fetchzip {
  url = "$NEW_URL";
  sha256 = "$(nix-prefetch-url --type sha256 --unpack "$NEW_URL")";
  stripRoot = false;
}
EOF

mv "$TEMP_FILE" "$OUTPUT_FILE"

echo "Windmill UI builder: UPDATE DONE"
