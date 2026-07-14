#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch unzip

set -e

FULL_VERSION="${1:-R-4.38-202512010920}"
VERSION=$(echo "$FULL_VERSION" | sed -E 's/R-([0-9]+\.[0-9]+)-.*/\1/')
BASE_URL="https://download.eclipse.org/eclipse/downloads/drops4/${FULL_VERSION}/swt-${VERSION}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NIX=$SCRIPT_DIR"/package.nix"

printf "Updating to version = %s; fullVersion = %s;" "$VERSION" "$FULL_VERSION"
sed -i "s/fullVersion = \".*\";/fullVersion = \"$FULL_VERSION\";/" "$PACKAGE_NIX"

PLATFORMS=(
  "x86_64-linux|gtk-linux-x86_64|true"
  "aarch64-linux|gtk-linux-aarch64|true"
  "ppc64le-linux|gtk-linux-ppc64le|true"
  "riscv64-linux|gtk-linux-riscv64|true"
  "x86_64-darwin|cocoa-macosx-x86_64|false"
  "aarch64-darwin|cocoa-macosx-aarch64|false"
)

for item in "${PLATFORMS[@]}"; do
  IFS='|' read -r NIX_PLAT E_PLAT IS_LINUX <<<"$item"
  URL="${BASE_URL}-${E_PLAT}.zip"

  HASH=""
  if [ "$IS_LINUX" == "true" ]; then
    HASH=$(nix-prefetch-url --type sha256 --unpack --name "source" "$URL" 2>/dev/null)
    TMP_DIR=$(mktemp -d)
    curl -sL "$URL" -o "$TMP_DIR/outer.zip"
    unzip -q "$TMP_DIR/outer.zip" src.zip -d "$TMP_DIR"
    mkdir "$TMP_DIR/out"
    unzip -q "$TMP_DIR/src.zip" -d "$TMP_DIR/out"
    HASH=$(nix hash path "$TMP_DIR/out")
    rm -rf "$TMP_DIR"
  else
    HASH=$(nix-prefetch-url --type sha256 --unpack "$URL" 2>/dev/null)
    HASH=$(nix hash to-sri --type sha256 "$HASH")
  fi

  sed -i "s|$NIX_PLAT.hash = \".*\";|$NIX_PLAT.hash = \"$HASH\";|" "$PACKAGE_NIX"
done
