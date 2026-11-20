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

jq --raw-output0 '.pins[] | select(.kind == "remoteSourceControl")' < "$stagingResolved" | while IFS= read -r -d "" pin; do
  url=$(jq --raw-output '.location' <<< "$pin")
  name=$(basename "$url" .git)
  rev=$(jq --raw-output '.state.revision' <<< "$pin")
  nix-prefetch-git --builder --quiet --fetch-submodules --url "$url" --rev "$rev" --out "$dest/Packages/$name"
done
