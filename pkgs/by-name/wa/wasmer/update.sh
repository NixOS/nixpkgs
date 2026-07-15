set -euo pipefail

pkg=pkgs/by-name/wa/wasmer/package.nix

die() {
  echo "update-wasmer: error: $*" >&2
  exit 1
}

[ -f "$pkg" ] || die "cannot find $pkg (run from the nixpkgs root)"

old_version=$(grep -oP '^  version = "\K[^"]+(?=";)' "$pkg")
echo "Current wasmer version: $old_version"

nix-update wasmer "$@"

new_version=$(grep -oP '^  version = "\K[^"]+(?=";)' "$pkg")
if [ "$old_version" = "$new_version" ]; then
  echo "Already at $old_version, nothing to do"
  exit 0
fi
echo "Updated wasmer $old_version -> $new_version"

# v8Version is pinned in package.nix to match PREBUILT_V8_VERSION in lib/napi/build.rs.
# lib/napi is a submodule, so resolve its pinned SHA first, then fetch build.rs from that repo.
echo "Fetching PREBUILT_V8_VERSION from lib/napi/build.rs..."
napi_sha=$(curl -fsSL "https://api.github.com/repos/wasmerio/wasmer/contents/lib/napi?ref=v${new_version}" \
           | grep -oP '"sha":\s*"\K[^"]+' | head -1) \
  || die "failed to query lib/napi submodule SHA for v${new_version} (does the tag exist?)"
[ -n "$napi_sha" ] || die "could not resolve lib/napi submodule SHA for v${new_version}"

new_v8=$(curl -fsSL "https://raw.githubusercontent.com/wasmerio/napi/${napi_sha}/build.rs" \
         | grep -oP 'PREBUILT_V8_VERSION\s*:\s*&str\s*=\s*"\K[^"]+') \
  || die "failed to fetch build.rs from wasmerio/napi@${napi_sha}"
[ -n "$new_v8" ] || die "could not parse PREBUILT_V8_VERSION from wasmerio/napi@${napi_sha}/build.rs (format may have changed)"

cur_v8=$(grep -oP '^  v8Version = "\K[^"]+(?=";)' "$pkg")
echo "V8: current=$cur_v8, required=$new_v8"

if [ "$new_v8" = "$cur_v8" ]; then
  echo "V8 version unchanged, done"
  exit 0
fi

# The asset filenames live in the v8Hashes attrset (also referenced by the
# assetName mapping below it). Treat package.nix as the single source of truth
# so this list can never drift from what the derivation actually fetches.
mapfile -t assets < <(grep -oP '^\s*"\Kv8-[^"]+\.tar\.xz(?=" = "sha256)' "$pkg")
[ "${#assets[@]}" -gt 0 ] || die "found no v8 assets in the v8Hashes attrset of $pkg"

echo "V8 bumped $cur_v8 -> $new_v8, fetching hashes for ${#assets[@]} platform(s)..."
sed -i "s|^  v8Version = \"[^\"]*\";$|  v8Version = \"$new_v8\";|" "$pkg"

base="https://github.com/wasmerio/v8-custom-builds/releases/download/$new_v8"
for asset in "${assets[@]}"; do
  url="$base/$asset"
  echo "  Fetching hash for $asset..."
  # Do not suppress errors here: a 404 usually means upstream renamed the asset
  # between releases (e.g. v8-darwin-arm64 -> v8-darwin-aarch64), in which case
  # the asset key in package.nix must be updated by hand before this can work.
  if ! raw=$(nix-prefetch-url --type sha256 "$url"); then
    die "could not download $url
    The asset may have been renamed in the $new_v8 release. Check
      https://github.com/wasmerio/v8-custom-builds/releases/tag/$new_v8
    and update the v8Hashes keys and the assetName mapping in $pkg to match,
    then re-run this script."
  fi
  hash=$(nix hash convert --hash-algo sha256 --to sri "$raw") \
    || die "failed to convert hash for $asset ($raw)"
  echo "  $asset -> $hash"
  sed -i "s|\"$asset\" = \"[^\"]*\"|\"$asset\" = \"$hash\"|" "$pkg"
  grep -qF "\"$asset\" = \"$hash\"" "$pkg" \
    || die "failed to write hash for $asset into $pkg (pattern did not match)"
done

echo "Done"
