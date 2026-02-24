#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused nix

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

owner="unisonweb"
repo="unison"
pname="unison-ucm"

# Fetch latest version
latest_tag=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest" | jq -r .tag_name)
version=${latest_tag#release/}

current_version=$(sed -nE 's/\s*version = "(.*)";/\1/p' package.nix)

if [[ "$version" == "$current_version" ]]; then
    echo "$pname is already up-to-date"
    exit 0
fi

echo "Updating $pname from $current_version to $version"

# Update version in the file
sed -i "s/version = \"$current_version\";/version = \"$version\";/" package.nix

# Define platforms and their corresponding URL suffixes
declare -A platforms=(
    ["aarch64-darwin"]="ucm-macos-arm64.tar.gz"
    ["x86_64-darwin"]="ucm-macos-x64.tar.gz"
    ["aarch64-linux"]="ucm-linux-arm64.tar.gz"
    ["x86_64-linux"]="ucm-linux-x64.tar.gz"
)

for platform in "${!platforms[@]}"; do
    filename="${platforms[$platform]}"
    url="https://github.com/$owner/$repo/releases/download/release/$version/$filename"

    echo "Prefetching $url for $platform..."
    hash=$(nix-prefetch-url "$url" --type sha256)
    sri_hash=$(nix hash convert --hash-algo sha256 --to sri "$hash")

    # Replace the hash for the specific platform
    # We look for the platform key, then the next hash line
    sed -i "/$platform = fetchurl/,/hash =/ s|hash = \".*\";|hash = \"$sri_hash\";|" package.nix
done

echo "Update complete."
