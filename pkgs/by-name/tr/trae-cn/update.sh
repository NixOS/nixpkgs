#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix dpkg
# shellcheck shell=bash
set -euo pipefail

cd -- "$(dirname "${BASH_SOURCE[0]}")"

CURRENT_VERSION=$(jq -r '.version' sources.json)

API_RESPONSE=$(curl -fsSL "https://api.trae.ai/icube/api/v1/native/version/trae/cn/latest" 2>/dev/null || true)

if [[ -z "$API_RESPONSE" ]]; then
  echo "Error: Could not fetch version info from API"
  exit 1
fi

LATEST_VERSION=$(echo "$API_RESPONSE" | jq -r '.data.manifest.linux.version' 2>/dev/null || true)

if [[ -z "$LATEST_VERSION" || "$LATEST_VERSION" == "null" ]]; then
  echo "Error: Could not determine latest version from API response"
  exit 1
fi

if [[ "$LATEST_VERSION" == "$CURRENT_VERSION" ]]; then
  echo "Already up to date ($LATEST_VERSION)"
  exit 0
fi

echo "Updating trae-cn: $CURRENT_VERSION -> $LATEST_VERSION"

SOURCES="{}"
VSCODE_VERSION=""

CN_LINUX_DOWNLOADS=$(echo "$API_RESPONSE" | jq -r '.data.manifest.linux.download[] | select(.region == "cn")')
CN_DARWIN_DOWNLOADS=$(echo "$API_RESPONSE" | jq -r '.data.manifest.darwin.download[] | select(.region == "cn")')

declare -A PLATFORM_URLS
PLATFORM_URLS[x86_64-linux]=$(echo "$CN_LINUX_DOWNLOADS" | jq -r '."x64.deb"')
PLATFORM_URLS[aarch64-linux]=$(echo "$CN_LINUX_DOWNLOADS" | jq -r '."arm64.deb"')
PLATFORM_URLS[x86_64-darwin]=$(echo "$CN_DARWIN_DOWNLOADS" | jq -r '."intel"')
PLATFORM_URLS[aarch64-darwin]=$(echo "$CN_DARWIN_DOWNLOADS" | jq -r '."apple"')

for sys in x86_64-linux aarch64-linux x86_64-darwin aarch64-darwin; do
  url="${PLATFORM_URLS[$sys]}"

  if [[ -z "$url" || "$url" == "null" ]]; then
    echo "Warning: No URL for $sys, skipping"
    continue
  fi

  echo "Fetching hash for $sys..."
  http_code=$(curl -fsSL -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || true)
  if [[ "$http_code" != "200" ]]; then
    echo "Warning: URL for $sys returned HTTP $http_code, skipping"
    continue
  fi

  if [[ "$url" == *"%20"* ]]; then
    ext="deb"
    arch="x64"
    case "$sys" in
      aarch64-linux) arch="arm64"; ext="deb" ;;
      x86_64-darwin) arch="x64"; ext="dmg" ;;
      aarch64-darwin) arch="arm64"; ext="dmg" ;;
    esac
    name="trae-cn-linux-${arch}.${ext}"
    hash=$(nix-prefetch-url --type sha256 --name "$name" "$url" 2>/dev/null)
  else
    hash=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)
  fi

  sri=$(nix-hash --type sha256 --to-sri "$hash")

  SOURCES=$(jq -n --argjson src "$SOURCES" --arg sys "$sys" --arg url "$url" --arg hash "$sri" \
    '$src + {($sys): {url: $url, hash: $hash}}')

  if [[ "$sys" == "x86_64-linux" ]]; then
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT
    deb_path=$(nix-prefetch-url --print-path --name "trae-cn-latest.deb" "$url" 2>/dev/null | tail -1)
    if command -v dpkg-deb &>/dev/null; then
      dpkg-deb --fsys-tarfile "$deb_path" 2>/dev/null | tar -x -C "$tmpdir" --no-same-permissions --no-same-owner "usr/share/trae-cn/resources/app/product.json" 2>/dev/null || true
      if [[ -f "$tmpdir/usr/share/trae-cn/resources/app/product.json" ]]; then
        VSCODE_VERSION=$(jq -r '.version' "$tmpdir/usr/share/trae-cn/resources/app/product.json" 2>/dev/null || echo "")
      fi
    fi
  fi
done

if [[ -z "$VSCODE_VERSION" ]]; then
  echo "Warning: Could not determine vscodeVersion, keeping current value"
  VSCODE_VERSION=$(jq -r '.vscodeVersion' sources.json)
fi

jq -n --arg v "$LATEST_VERSION" --arg vs "$VSCODE_VERSION" --argjson s "$SOURCES" \
  '{version: $v, vscodeVersion: $vs, sources: $s}' > sources.json

echo "Updated to $LATEST_VERSION (VS Code $VSCODE_VERSION)"
