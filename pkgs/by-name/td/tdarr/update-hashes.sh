#!/usr/bin/env bash

# Extract version from package.nix (or default.nix) in the same directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIX_FILE="${SCRIPT_DIR}/package.nix"

# Try package.nix first, fall back to default.nix
if [[ ! -f "$NIX_FILE" ]]; then
    NIX_FILE="${SCRIPT_DIR}/default.nix"
fi

# Extract version using nix-instantiate
VERSION=$(nix-instantiate --eval --expr "(import ${NIX_FILE} {}).version or (import ${NIX_FILE} {}).pname" 2>/dev/null | tr -d '"')

# Fallback: try to grep for version = "..." pattern
if [[ -z "$VERSION" ]]; then
    VERSION=$(grep -oP '(?<=version = ")[^"]+' "$NIX_FILE" 2>/dev/null)
fi

if [[ -z "$VERSION" ]]; then
    echo "Error: Could not extract version from $NIX_FILE" >&2
    exit 1
fi

echo "Using version: $VERSION" >&2

fetch_and_convert() {
    local url=$1
    local hash=$(nix-prefetch-url "$url" 2>/dev/null)
    nix hash to-sri --type sha256 "$hash"
}

echo "hashes = {"
echo "  linux_x64 = {"
echo "    server = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/linux_x64/Tdarr_Server.zip)\";"
echo "    node = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/linux_x64/Tdarr_Node.zip)\";"
echo "  };"
echo "  linux_arm64 = {"
echo "    server = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/linux_arm64/Tdarr_Server.zip)\";"
echo "    node = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/linux_arm64/Tdarr_Node.zip)\";"
echo "  };"
echo "  darwin_x64 = {"
echo "    server = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/darwin_x64/Tdarr_Server.zip)\";"
echo "    node = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/darwin_x64/Tdarr_Node.zip)\";"
echo "  };"
echo "  darwin_arm64 = {"
echo "    server = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/darwin_arm64/Tdarr_Server.zip)\";"
echo "    node = \"$(fetch_and_convert https://storage.tdarr.io/versions/$VERSION/darwin_arm64/Tdarr_Node.zip)\";"
echo "  };"
echo "};"
