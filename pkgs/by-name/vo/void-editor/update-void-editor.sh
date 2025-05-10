#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq coreutils common-updater-scripts
set -eu -o pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; void-editor.version or (lib.getVersion void-editor)" | tr -d '"')
# VOID_EDITOR_VERSION=${VOID_EDITOR_VERSION:-}
declare -A platforms=( [x86_64-linux]='linux-x64' [aarch64-linux]='linux-arm64' [x86_64-darwin]='darwin-x64' [aarch64-darwin]='darwin-arm64' [armv7l-linux]='linux-armhf' )
declare -A archive_fmts=( [x86_64-linux]='tar.gz' [aarch64-linux]='tar.gz' [x86_64-darwin]='zip' [aarch64-darwin]='zip' [armv7l-linux]='tar.gz' )
declare -A updates=( )
first_version=""

for platform in "${!platforms[@]}"; do
    arch="${platforms[$platform]}"
    archive_fmt="${archive_fmts[$platform]}"
    version=$(curl -Ls -w %{url_effective} -o /dev/null https://github.com/voideditor/binaries/releases/latest | awk -F'/' '{print $NF}')

    if [[ "$version" == "$currentVersion" ]]; then
      >&2 echo "Latest version is current: $version $currentVersion"
      exit 0
    fi
    if [[ -z "$first_version" ]]; then
      first_version="$version"
      first_platform="$platform"
    elif [[ "$version" != "$first_version" ]]; then
      >&2 echo "Multiple versions found: $first_version ($first_platform) and $version ($platform)"
      exit 1
    fi
    url="https://github.com/voideditor/binaries/releases/download/${version}/Void-${arch}-${version}.${archive_fmt}"
    # Exits with code 22 if not downloadable
    curl --output /dev/null --silent --head --fail "$url" && >&2 echo "Downloaded $version for $platform"
    updates+=( [$platform]="$(jq --arg version "$version" --arg url "$url" -nc '$ARGS.named | {version, url}')" )
done

# Install updates
for platform in "${!updates[@]}"; do
  result=${updates[$platform]}
  version=$(jq -r '.version' <<<"$result")
  url=$(jq -r '.url' <<<"$result")
  source=$(nix-prefetch-url "$url" --name "void-editor-$version")
  hash=$(nix-hash --to-sri --type sha256 "$source")
  update-source-version void-editor "$version" "$hash" --system="$platform" --ignore-same-version --source-key="sources.$platform"
done
