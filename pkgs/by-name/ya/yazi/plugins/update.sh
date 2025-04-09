#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq git

set -e

# Basic setup and validation
NIXPKGS_DIR="$PWD"

if [ "${PLUGIN_NAME:-}" = "" ] || [ "${PLUGIN_PNAME:-}" = "" ]; then
    echo "Error: PLUGIN_NAME and PLUGIN_PNAME environment variables must be set"
    exit 1
fi

PLUGIN_DIR="$NIXPKGS_DIR/pkgs/by-name/ya/yazi/plugins/$PLUGIN_NAME"
if [ ! -f "$PLUGIN_DIR/default.nix" ]; then
    echo "Error: Could not find default.nix for plugin $PLUGIN_NAME at $PLUGIN_DIR"
    exit 1
fi

GITHUB_HEADER=(-H "Accept: application/vnd.github.v3+json")
if [ "${GITHUB_TOKEN:-}" != "" ]; then
    GITHUB_HEADER+=(-H "Authorization: token $GITHUB_TOKEN")
fi

# Get repository info and Yazi version
OWNER=$(nix eval --raw -f "$NIXPKGS_DIR" yaziPlugins."$PLUGIN_NAME".src.owner)
REPO=$(nix eval --raw -f "$NIXPKGS_DIR" yaziPlugins."$PLUGIN_NAME".src.repo)
YAZI_VERSION=$(nix eval --raw -f "$NIXPKGS_DIR" yazi-unwrapped.version)

# Check plugin compatibility with current Yazi version
PLUGIN_PATH="$([[ $OWNER == "yazi-rs" ]] && echo "$PLUGIN_PNAME/" || echo "")"
MAIN_LUA_URL="https://raw.githubusercontent.com/$OWNER/$REPO/main/${PLUGIN_PATH}main.lua"
PLUGIN_CONTENT=$(curl --silent "${GITHUB_HEADER[@]}" "$MAIN_LUA_URL")
REQUIRED_VERSION=$(echo "$PLUGIN_CONTENT" | head -n 1 | grep -o "since [0-9.]*" | sed 's/since \([0-9.]*\)/\1/')

# If no version requirement is found, default to "0"
if [ "$REQUIRED_VERSION" = "" ]; then
    echo "No version requirement found for $PLUGIN_NAME, assuming compatible with any Yazi version"
    REQUIRED_VERSION="0"
else
    # Check if the plugin is compatible with current Yazi version
    if ! printf "%s\n%s\n" "$REQUIRED_VERSION" "$YAZI_VERSION" | sort -C -V; then
        echo "$PLUGIN_NAME plugin requires Yazi $REQUIRED_VERSION, but we have $YAZI_VERSION"
        exit 0
    fi
fi

# Get latest commit info
if [ "$OWNER" == "yazi-rs" ]; then
    # For official plugins, get commit info for the specific plugin file
    API_URL="https://api.github.com/repos/$OWNER/$REPO/commits?path=$PLUGIN_PNAME/main.lua&per_page=1"
else
    # For third-party plugins, get latest commit on main branch
    API_URL="https://api.github.com/repos/$OWNER/$REPO/commits/main"
fi

if [ "$OWNER" == "yazi-rs" ]; then
    COMMIT_DATA=$(curl --silent "${GITHUB_HEADER[@]}" "$API_URL")
    LATEST_COMMIT=$(echo "$COMMIT_DATA" | jq -r '.[0].sha')
    COMMIT_DATE=$(echo "$COMMIT_DATA" | jq -r '.[0].commit.committer.date' | cut -d'T' -f1)
else
    COMMIT_DATA=$(curl --silent "${GITHUB_HEADER[@]}" "$API_URL")
    LATEST_COMMIT=$(echo "$COMMIT_DATA" | jq -r '.sha')
    COMMIT_DATE=$(echo "$COMMIT_DATA" | jq -r '.commit.committer.date' | cut -d'T' -f1)
fi

if [ "$LATEST_COMMIT" = "" ] || [ "$LATEST_COMMIT" == "null" ]; then
    echo "Error: Could not get latest commit hash for $PLUGIN_NAME"
    exit 1
fi

echo "Updating $PLUGIN_NAME to commit $LATEST_COMMIT ($COMMIT_DATE)"

# Update version and revision
NEW_VERSION="${REQUIRED_VERSION}-unstable-${COMMIT_DATE}"

# Update the revision in default.nix
sed -i "s/rev = \"[^\"]*\"/rev = \"$LATEST_COMMIT\"/" "$PLUGIN_DIR/default.nix"

# Update the version in default.nix
if grep -q 'version = "' "$PLUGIN_DIR/default.nix"; then
    sed -i "s/version = \"[^\"]*\"/version = \"$NEW_VERSION\"/" "$PLUGIN_DIR/default.nix"
else
    # Add version attribute after pname if it doesn't exist
    sed -i "/pname = \"[^\"]*\"/a \ \ version = \"$NEW_VERSION\";" "$PLUGIN_DIR/default.nix"
fi

# Update the hash
# Calculate hash directly for all plugins
PREFETCH_URL="https://github.com/$OWNER/$REPO/archive/$LATEST_COMMIT.tar.gz"

# Get the hash directly in SRI format
NEW_HASH=$(nix-prefetch-url --unpack --type sha256 "$PREFETCH_URL" 2>/dev/null)

# If the hash is not in SRI format, convert it
if [[ ! "$NEW_HASH" =~ ^sha256- ]]; then
    # Try to convert the hash to SRI format
    NEW_HASH=$(nix hash to-sri --type sha256 "$NEW_HASH" 2>/dev/null)

    # If that fails, try another approach
    if [[ ! "$NEW_HASH" =~ ^sha256- ]]; then
        echo "Warning: Failed to get SRI hash directly, trying alternative method..."
        RAW_HASH=$(nix-prefetch-url --type sha256 "$PREFETCH_URL" 2>/dev/null)
        NEW_HASH=$(nix hash to-sri --type sha256 "$RAW_HASH" 2>/dev/null)
    fi
fi

# Verify we got a valid SRI hash (starts with sha256-)
if [[ ! "$NEW_HASH" =~ ^sha256- ]]; then
    echo "Error: Failed to generate valid SRI hash. Output was:"
    echo "$NEW_HASH"
    exit 1
fi

echo "Generated SRI hash: $NEW_HASH"

# Update hash in default.nix
if grep -q 'hash = "' "$PLUGIN_DIR/default.nix"; then
    sed -i "s|hash = \"[^\"]*\"|hash = \"$NEW_HASH\"|" "$PLUGIN_DIR/default.nix"
else
    # For files that use fetchFromGitHub, update the hash there
    if grep -q 'fetchFromGitHub' "$PLUGIN_DIR/default.nix"; then
        sed -i "s|sha256 = \"[^\"]*\"|sha256 = \"$NEW_HASH\"|" "$PLUGIN_DIR/default.nix"
    else
        echo "Error: Could not find hash attribute in $PLUGIN_DIR/default.nix"
        exit 1
    fi
fi

# Verify the hash was updated
if grep -q "hash = \"$NEW_HASH\"" "$PLUGIN_DIR/default.nix" || grep -q "sha256 = \"$NEW_HASH\"" "$PLUGIN_DIR/default.nix"; then
    echo "Successfully updated hash to: $NEW_HASH"
else
    echo "Error: Failed to update hash in $PLUGIN_DIR/default.nix"
    exit 1
fi

# Update the revision in default.nix
sed -i "s/rev = \"[^\"]*\"/rev = \"$LATEST_COMMIT\"/" "$PLUGIN_DIR/default.nix"

echo "Successfully updated $PLUGIN_NAME to version $NEW_VERSION (commit $LATEST_COMMIT)"
