{
  lib,
  coreutils,
  jq,
  nix,
  nix-prefetch-git,
  writeShellScriptBin,
}:

writeShellScriptBin "prefetch-swiftpm-deps" ''
  set -eu -o pipefail

  resolved=''${1-}
  dest=''${2-}

  if [ -z "$resolved" ]; then
      echo "usage: $0 <path/to/Package.resolved>" >&2
      echo >&2
      echo "Prefetches SwiftPM dependencies for use by fetchSwiftPMDeps." >&2
      exit 1
  fi
  resolved=$(realpath "$resolved")

  if [ -z "''${2-}" ]; then
    dest=$(${lib.escapeShellArg (lib.getExe' coreutils "mktemp")} -d)
    trap '${lib.escapeShellArg (lib.getExe' nix "nix-hash")} --sri --type sha256 "$dest"; rm -rf -- "$dest"' EXIT
  fi
  dest=$(realpath "$dest")

  stagingResolved=$dest/Package.resolved

  # Convert version 1 to version 2 because its pins `schema` differs.
  # Version 3 has the same pins schema, so it is already compatible.
  if [ "$(${lib.escapeShellArg (lib.getExe jq)} --raw-output '.version' < "$resolved")" = "1" ]; then
    ${lib.escapeShellArg (lib.getExe jq)} '
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

  if [ -n "$(${lib.escapeShellArg (lib.getExe jq)} --raw-output '.pins[] | select(.kind != "remoteSourceControl")' < "$stagingResolved")" ]; then
    echo "Only Git-based dependencies are supported by fetchSwiftPMDeps"
    exit 1
  fi

  ${lib.escapeShellArg (lib.getExe jq)} --raw-output0 '.pins[] | select(.kind == "remoteSourceControl")' < "$stagingResolved" | while IFS= read -d "" pin; do
    url=$(${lib.escapeShellArg (lib.getExe jq)} --raw-output '.location' <<< "$pin")
    name=$(basename "$url" .git)
    rev=$(${lib.escapeShellArg (lib.getExe jq)} --raw-output '.state.revision' <<< "$pin")
    ${lib.escapeShellArg (lib.getExe nix-prefetch-git)} --builder --quiet --fetch-submodules --url "$url" --rev "$rev" --out "$dest/Packages/$name"
  done
''
