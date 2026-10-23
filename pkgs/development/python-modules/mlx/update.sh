nix-update "$UPDATE_NIX_ATTR_PATH"

version=$(nix eval --raw --file . "$UPDATE_NIX_ATTR_PATH.version")

# Use perl multiline matching to extract the correct FetchContent_Declare.
rev=$(
  curl -fsSL "https://raw.githubusercontent.com/ml-explore/mlx/v$version/mlx/io/CMakeLists.txt" |
    perl -0777 -ne '
      if (/FetchContent_Declare\s*\(\s*gguflib\b.*?\bGIT_TAG\s+([^\s)]+)/s) {
        print "$1\n";
      }
    '
)
if [[ -z "$rev" ]]; then
  echo "Could not determine the gguf-tools revision for MLX $version" >&2
  exit 1
fi

current_rev=$(nix eval --raw --file . "$UPDATE_NIX_ATTR_PATH.gguf-tools.rev")
if [[ "$rev" != "$current_rev" ]]; then
  update-source-version \
    "$UPDATE_NIX_ATTR_PATH" \
    --source-key=gguf-tools \
    --rev="$rev" \
    --ignore-same-version
fi
