#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nix

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Get latest tag from GitHub API (since releases are not up to date)
latest_tag=$(curl -s "https://api.github.com/repos/mediar-ai/terminator/tags" | jq -r '.[0].name')

# Remove 'v' prefix if present
latest_version=${latest_tag#v}

echo "Latest version: $latest_version"

# Get current version from package.nix
current_version=$(grep -o 'version = "[^"]*"' package.nix | cut -d'"' -f2)

echo "Current version: $current_version"

if [ "$latest_version" = "$current_version" ]; then
    echo "Already up to date"
    exit 0
fi

# Update the version in package.nix using sed
sed -i "s/version = \"[^\"]*\"/version = \"$latest_version\"/" package.nix

echo "Updated version from $current_version to $latest_version"

# Update platform binary hashes
declare -A platform_urls=(
    ["linux-x64-gnu"]="terminator-mcp-linux-x64-gnu"
    ["darwin-x64"]="terminator-mcp-darwin-x64"
    ["darwin-arm64"]="terminator-mcp-darwin-arm64"
)

for platform in "${!platform_urls[@]}"; do
    url_name="${platform_urls[$platform]}"
    
    echo "Updating hash for $platform..."
    
    # Construct the URL
    url="https://registry.npmjs.org/$url_name/-/$url_name-$latest_version.tgz"
    
    # Get the hash
    hash=$(nix-prefetch-url "$url" 2>/dev/null || echo "")
    
    if [ -n "$hash" ]; then
        # Convert to SRI format
        sri_hash=$(nix-hash --to-sri --type sha256 "$hash")
        
        # Update the hash for this specific URL pattern - more targeted replacement
        # First update the URL version
        sed -i "s|$url_name-[^/]*/[^/]*|$url_name-$latest_version|g" package.nix
        
        # Then update the hash that appears after this URL
        sed -i "/$url_name-$latest_version/,/hash = /s/hash = \"[^\"]*\"/hash = \"$sri_hash\"/" package.nix
        
        echo "Updated $platform hash to $sri_hash"
    else
        echo "Warning: Could not fetch hash for $platform"
    fi
done

echo "Updated terminator-mcp-agent to version $latest_version"