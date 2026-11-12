nix-update "$UPDATE_NIX_ATTR_PATH" --version-regex='^([0-9.]+)$' "$@"

version=$(nix eval --raw --file . "$UPDATE_NIX_ATTR_PATH.version")
release_date=$(
  curl -fsSL "https://api.github.com/repos/pypdfium2-team/pypdfium2/commits/$version" |
    jq -er '.commit.committer.date'
)

# The fork has no release tags. Select its head at the time of the release,
# then verify it against the source bundled in the published distribution.
rev=$(
  curl -fsSL --get "https://api.github.com/repos/pypdfium2-team/ctypesgen/commits" \
    --data-urlencode 'sha=pypdfium2' \
    --data-urlencode "until=$release_date" \
    --data-urlencode 'per_page=1' |
    jq -er '.[0].sha'
)

sdist_url=$(
  curl -fsSL "https://pypi.org/pypi/pypdfium2/$version/json" |
    jq -er '.urls[] | select(.packagetype == "sdist") | .url'
)

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

extract_archive() {
  local url="$1"
  local destination="$2"

  mkdir -p "$destination"
  curl -fsSL "$url" | tar -xz --strip-components=1 -C "$destination"
}

extract_archive "$sdist_url" "$workdir/pypdfium2"
extract_archive "https://github.com/pypdfium2-team/ctypesgen/archive/$rev.tar.gz" "$workdir/ctypesgen"

if ! diff -qr "$workdir/pypdfium2/deps/ctypesgen/src" "$workdir/ctypesgen/src"; then
  echo "ctypesgen $rev does not match the source bundled with pypdfium2 $version" >&2
  exit 1
fi

current_rev=$(nix eval --raw --file . "$UPDATE_NIX_ATTR_PATH.ctypesgen.rev")
if [[ "$rev" != "$current_rev" ]]; then
  update-source-version \
    "$UPDATE_NIX_ATTR_PATH" \
    --source-key=ctypesgen \
    --rev="$rev" \
    --ignore-same-version
fi
