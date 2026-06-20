#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update nodejs elmPackages.elm jq nix gitMinimal

set -euo pipefail

# shows time before each line, to help expose slow steps
export PS4='+ $(date "+%H:%M:%S") '

NIXPKGS_DIR="$(git rev-parse --show-toplevel)"
PACKAGE_DIR="$(realpath "$(dirname "$0")")"

# with this, it works by directly calling this script
UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-elmPackages.elm-test-rs}"
ELM_VERSION=$(nix-instantiate --eval -A elmPackages.elm.version $NIXPKGS_DIR --raw)

nix-update "$UPDATE_NIX_ATTR_PATH"
SRC_DIR="$(nix-build -A "${UPDATE_NIX_ATTR_PATH}.src" --no-out-link)"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

# NOTE: dwyane/elm2nix should be used ideally BUT we can't use it
# Due to https://github.com/dwayne/elm2nix/issues/3

# for elm to be able to write into local folders
cp -r "$SRC_DIR"/* "$WORK_DIR"/
chmod -R +w "$WORK_DIR"

cd "$WORK_DIR"

# clean elm home
export ELM_HOME="$WORK_DIR/.elm"

# for every elm.json in the repo force elm to resolve it
while read -r elm_file; do
  (
    dir=$(dirname "$elm_file")
    echo "Resolving Elm dependencies in $dir"
    cd "$dir"
    # 'elm make' on a non-existent file will fail, but not before it
    # solves and downloads all dependencies in the elm.json!
    elm make src/Fake.elm --output=/dev/null >/dev/null 2>&1 || true
  ) &
done < <(find . -name "elm.json" -type f)

wait

ELM_PACKAGES="$ELM_HOME/$ELM_VERSION/packages"

if [ ! -d "$ELM_PACKAGES" ]; then
  echo "Error: Elm cache was not generated at $ELM_PACKAGES" >&2
  exit 1
fi

# crawl the cache and collect dependencies
deps=()
for author_dir in "$ELM_PACKAGES"/*; do
  [ -d "$author_dir" ] || continue
  author=$(basename "$author_dir")
  for package_dir in "$author_dir"/*; do
    [ -d "$package_dir" ] || continue
    package=$(basename "$package_dir")
    for version_dir in "$package_dir"/*; do
      [ -d "$version_dir" ] || continue
      version=$(basename "$version_dir")
      deps+=("$author $package $version")
    done
  done
done

# add this dependency separately, the program adds it at runtime before running the tests
# hardcoded version obtained from src/deps.rs in solve_helper function
deps+=("mpizenberg elm-test-runner 6.0.0")

echo "Prefetching ${#deps[@]} Elm dependencies"

# fetch hashes in parallel and combine into JSON
fetch_dep() {
  local author=$1
  local package=$2
  local version=$3
  local url="https://github.com/${author}/${package}/archive/${version}.tar.gz"
  local sha256

  if sha256=$(nix-prefetch-url --unpack "$url" 2>/dev/null); then
    # Generate an isolated JSON object for this dependency
    jq -n --arg author "$author" --arg package "$package" --arg version "$version" --arg sha256 "$sha256" \
      '{author: $author, package: $package, version: $version, sha256: $sha256}'
  else
    echo "Failed to fetch $url" >&2
    exit 1
  fi
}
export -f fetch_dep

# run up to 8 fetches concurrently, and merge outputs into an array
# we create a dwayne/elm2nix compatible lock file
printf "%s\n" "${deps[@]}" |
  xargs -n 3 -P 8 bash -c 'fetch_dep "$1" "$2" "$3"' _ |
  jq -s 'sort_by(.author, .package, .version)' >"$PACKAGE_DIR/elm-srcs.json"


# NOTE: dwayne/elm2nix could be in nixpkgs like yarn2nix-moretea
# but maybe when it also supports fetching deps from "package" type
# see https://github.com/dwayne/elm2nix/issues/4

# create a registry.dat for just this lockfile using dwayne/elm2nix
# this file is very important and has the exact information required for elm to work offline
# with incomplete registry info it will fail at runtime while trying to validate it
"$(
  nix build \
  --extra-experimental-features "flakes nix-command" \
  github:dwayne/elm2nix/e84ab8872f1660f5576df19adeb9e1a682402bb4 \
  --print-out-paths --no-link \
)"/bin/elm2nix \
  registry generate \
  -i "$PACKAGE_DIR/elm-srcs.json" \
  -o "$PACKAGE_DIR/registry.dat"

echo "Files elm-srcs.json and registry.dat updated successfully"
