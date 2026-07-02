old_version=$(grep -oP '^  version = "\K[^"]+(?=";)' pkgs/by-name/wa/wasmer/package.nix)
echo "Current wasmer version: $old_version"

nix-update wasmer "$@"

new_version=$(grep -oP '^  version = "\K[^"]+(?=";)' pkgs/by-name/wa/wasmer/package.nix)
if [ "$old_version" = "$new_version" ]; then
  echo "Already at $old_version, nothing to do"
  exit 0
fi
echo "Updated wasmer $old_version -> $new_version"

# v8Version is pinned in package.nix to match PREBUILT_V8_VERSION in lib/napi/build.rs.
# lib/napi is a submodule, so resolve its pinned SHA first, then fetch build.rs from that repo.
echo "Fetching PREBUILT_V8_VERSION from lib/napi/build.rs..."
napi_sha=$(curl -fsSL "https://api.github.com/repos/wasmerio/wasmer/contents/lib/napi?ref=v${new_version}" \
           | grep -oP '"sha":\s*"\K[^"]+' | head -1)
new_v8=$(curl -fsSL "https://raw.githubusercontent.com/wasmerio/napi/${napi_sha}/build.rs" \
         | grep -oP 'PREBUILT_V8_VERSION\s*:\s*&str\s*=\s*"\K[^"]+')
cur_v8=$(grep -oP '^  v8Version = "\K[^"]+(?=";)' pkgs/by-name/wa/wasmer/package.nix)
echo "V8: current=$cur_v8, required=$new_v8"

if [ "$new_v8" = "$cur_v8" ]; then
  echo "V8 version unchanged, done"
  exit 0
fi

echo "V8 bumped $cur_v8 -> $new_v8, fetching hashes for all platforms..."
sed -i "s|^  v8Version = \"[^\"]*\";$|  v8Version = \"$new_v8\";|" \
  pkgs/by-name/wa/wasmer/package.nix

base="https://github.com/wasmerio/v8-custom-builds/releases/download/$new_v8"
declare -A assets=(
  ["v8-linux-amd64.tar.xz"]="$base/v8-linux-amd64.tar.xz"
  ["v8-linux-musl-amd64.tar.xz"]="$base/v8-linux-musl-amd64.tar.xz"
  ["v8-darwin-arm64.tar.xz"]="$base/v8-darwin-arm64.tar.xz"
)

for asset in "${!assets[@]}"; do
  url="${assets[$asset]}"
  echo "  Fetching hash for $asset..."
  hash=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null \
         | xargs nix hash convert --hash-algo sha256 --to sri)
  echo "  $asset -> $hash"
  sed -i "s|\"$asset\" = \"[^\"]*\"|\"$asset\" = \"$hash\"|" \
    pkgs/by-name/wa/wasmer/package.nix
done

echo "Done"
