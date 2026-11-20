#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=. -i bash -p git jq nix nix-prefetch-git nix-prefetch-github moreutils prefetch-npm-deps prefetch-swiftpm-deps swift swiftpm

set -eu -o pipefail

function usage() {
    echo "Usage: update.sh <swift version> <swift-docc-render rev> <swift-tools-protocols version>" >&2
    exit 1
}

if [[ -z "${1:-}" || -z "${2:-}" || -z "${3:-}" ]]; then
    usage
fi

SWIFT_VERSION=$1
SWIFT_DOCC_RENDER_REV=$2
SWIFT_TOOLS_PROTOCOLS_VERSION=$3

SCRIPT_DIR=$(dirname "$(realpath $0)")

SOURCES=$SCRIPT_DIR/sources.json
NEW_SOURCES=$SCRIPT_DIR/sources-new.json


function get_package_path() {
    case "$1" in
        swift)
            echo "$SCRIPT_DIR/by-name/sw/swiftc"
            ;;
        swift-package-manager)
            echo "$SCRIPT_DIR/by-name/sw/swiftpm"
            ;;
        *)
            echo "$SCRIPT_DIR/by-name/${1:0:2}/$1"
            ;;
    esac
}

function fetchgit() {
    local owner=swiftlang # All Swift toolchain packages are owned by “swiftlang”.
    local repo=$1
    local rev=$(get_rev "$repo")
    nix-prefetch-github --json --rev "$rev" "$owner" "$repo"
}

function get_hash() {
    jq -r '.hash'
}

function get_rev() {
    # If these ever get tagged following the toolchain naming convention, these special cases can be dropped.
    case "$1" in
        swift-docc-render)
            echo "$SWIFT_DOCC_RENDER_REV"
            ;;
        swift-tools-protocols)
            echo "$SWIFT_TOOLS_PROTOCOLS_VERSION"
            ;;
        *)
            jq -r --arg pkg "$1" --arg swift_version "$SWIFT_VERSION" \
                '.[$pkg].rev // .[$pkg].version // "swift-" + $swift_version + "-RELEASE"' "$SOURCES"
            ;;
    esac
}

function get_npm_hash() {
    local package=$1
    local path=$(get_package_path "$package")
    local rev=$(get_rev "$package")

    git_tmp=$(mktemp -d)
    trap 'rm -rf -- "$git_tmp"' RETURN

    nix-prefetch-git --builder --quiet --fetch-submodules --url "https://github.com/swiftlang/$package.git" --rev "$rev" --out "$git_tmp"

    prefetch-npm-deps "$git_tmp/package-lock.json"
}

function get_swiftpm_hash() {
    local package=$1
    local path=$(get_package_path "$package")
    local rev=$(get_rev "$package")

    git_tmp=$(mktemp -d)
    trap 'rm -rf -- "$git_tmp"' RETURN

    nix-prefetch-git --builder --quiet --fetch-submodules --url "https://github.com/swiftlang/$package.git" --rev "$rev" --out "$git_tmp"

    if [ ! -f "$git_tmp/Package.resolved" ]; then
        pushd "$git_tmp" > /dev/null
        swift package resolve &> /dev/null
        cp Package.resolved "$path/Package.resolved"
        popd > /dev/null
    fi

    prefetch-swiftpm-deps "$git_tmp/Package.resolved"
}


function has_npm_deps() {
    local package=$1
    jq -r --arg pkg "$1" '.[$pkg] | has("npmDeps")' "$SOURCES" | xargs -I '{}' test '{}' = "true"
}

function has_swiftpm_deps() {
    jq -r --arg pkg "$1" '.[$pkg] | has("swiftpmDeps")' "$SOURCES" | xargs -I '{}' test '{}' = "true"
}

echo "Updating source.json for Swift version $SWIFT_VERSION"

declare -a packages
readarray -t packages <<< $(jq -r '. | keys | .[]' < "$SOURCES")

updatedPackages="{}"

for package in "${packages[@]}"; do
    printf "%s" "  - Locking $package at $(get_rev "$package") ... "

    src=$(fetchgit "$package")
    pkg=$(jq --arg name "$package" '{$name: {"hash": .hash}}' <<< "$src")

    # Some packages require specific versions, which are stored in the JSON along with the hashes.
    case "$package" in
        swift-docc-render)
            pkg=$(jq --arg rev "$SWIFT_DOCC_RENDER_REV" '. * {"swift-docc-render": {"rev": $rev}}' <<< "$pkg")
            ;;
        swift-tools-protocols)
            pkg=$(jq --arg version "$SWIFT_TOOLS_PROTOCOLS_VERSION" '. * {"swift-tools-protocols": {"version": $version}}' <<< "$pkg")
            ;;
    esac

    updatedPackages=$(jq --argjson pkg "$pkg" -S '. * $pkg' <<< "$updatedPackages")

    echoStr="done (hash: $(get_hash "$package" <<< "$src")"

    if has_swiftpm_deps "$package"; then
        swiftpmHash=$(get_swiftpm_hash "$package")
        echoStr+="; swiftpmDeps hash: ${swiftpmHash-n/a}"
        updatedPackages=$(
            jq --arg swiftpmHash "$swiftpmHash" --arg pkg "$package" \
              '. * {$pkg: {"swiftpmDeps": {"hash": $swiftpmHash}}}' <<< "$updatedPackages"
        )
    fi

    if has_npm_deps "$package"; then
        npmHash=$(get_npm_hash "$package")
        echoStr+="; npmDeps hash: ${npmHash-n/a}"
        updatedPackages=$(
            jq --arg npmHash "$npmHash" --arg pkg "$package" \
                '. * {$pkg: {"npmDeps": {"hash": $npmHash}}}' <<< "$updatedPackages"
        )
    fi

    echoStr+=")"

    echo "$echoStr"
done

echo "$updatedPackages" > "$SOURCES"
echo "$SWIFT_VERSION" > "$SCRIPT_DIR/swift-version"
