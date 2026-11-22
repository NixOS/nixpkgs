resolved=${1-}
dest=${2-}

if [ -z "$resolved" ]; then
    echo "usage: $0 <path/to/Package.resolved>" >&2
    echo >&2
    echo "Prefetches SwiftPM dependencies for use by fetchSwiftPMDeps." >&2
    exit 1
fi
resolved=$(realpath "$resolved")

if [ -z "${2-}" ]; then
  dest=$(mktemp -d)
  trap 'nix-hash --sri --type sha256 "$dest"; rm -rf -- "$dest"' EXIT
fi
dest=$(realpath "$dest")

stagingResolved=$dest/Package.resolved

# Convert version 1 to version 2 because its pins `schema` differs.
# Version 3 has the same pins schema, so it is already compatible.
if [ "$(jq --raw-output '.version' < "$resolved")" = "1" ]; then
  jq '
     {
         pins: [
             .object.pins[] | {
                 identity: .package,
                 kind: "remoteSourceControl",
                 location: .repositoryURL,
                 state: .state
             }
         ],
         version: 2
     }
  ' < "$resolved" > "$stagingResolved"
else
  cp "$resolved" "$stagingResolved"
fi

if [ -n "$(jq --raw-output '.pins[] | select(.kind != "remoteSourceControl")' < "$stagingResolved")" ]; then
  echo "Only Git-based dependencies are supported by fetchSwiftPMDeps"
  exit 1
fi

fetchBinaryTargets() {
  local name=$1 location=$2 identity=$3
  local scratch target url checksum dir xcframework
  scratch=$(mktemp -d)

  HOME=$scratch swift-package --disable-sandbox --package-path "$dest/Packages/$name" --scratch-path "$scratch/build" dump-package \
    | jq --raw-output '.targets[] | select(.type == "binary" and .url) | "\(.name) \(.url) \(.checksum)"' \
    > "$scratch/targets"

  while read -r target url checksum; do
    dir=$dest/artifacts/$name/$target
    curl --fail --silent --show-error --location --retry 3 --output "$scratch/$target.zip" "$url"
    echo "$checksum  $scratch/$target.zip" | sha256sum --check --quiet
    mkdir -p "$dir"
    unzip -q "$scratch/$target.zip" -d "$dir"
    rm -rf "$dir/__MACOSX"

    xcframework=$(find "$dir" -mindepth 1 -maxdepth 1 -name '*.xcframework' -printf '%f')
    if [ -z "$xcframework" ]; then
      echo "$name: binary target $target is not an XCFramework, which fetchSwiftPMDeps does not support" >&2
      exit 1
    fi

    jq --null-input --compact-output --sort-keys \
      --arg name "$name" --arg location "$location" --arg identity "$identity" \
      --arg target "$target" --arg url "$url" --arg checksum "$checksum" \
      --arg path "artifacts/$name/$target/$xcframework" '
        {
            "kind": { "xcframework": { } },
            "packageRef": {
                "identity": $name,
                "kind": "remoteSourceControl",
                "location": $location,
                "name": $identity
            },
            "path": $path,
            "source": {
                "checksum": $checksum,
                "type": "remote",
                "url": $url
            },
            "targetName": $target
        }
      ' >> "$dest/artifacts.jsonl"
  done < "$scratch/targets"

  rm -rf "$scratch"
}

jq --raw-output0 '.pins[] | select(.kind == "remoteSourceControl")' < "$stagingResolved" | while IFS= read -r -d "" pin; do
  url=$(jq --raw-output '.location' <<< "$pin")
  name=$(basename "$url" .git)
  rev=$(jq --raw-output '.state.revision' <<< "$pin")
  nix-prefetch-git --builder --quiet --fetch-submodules --url "$url" --rev "$rev" --out "$dest/Packages/$name"

  if grep -q binaryTarget "$dest/Packages/$name/Package.swift"; then
    fetchBinaryTargets "$name" "$url" "$(jq --raw-output '.identity' <<< "$pin")"
  fi
done
