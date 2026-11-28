# shellcheck shell=bash

swiftpmDumpLocalPackages() {
    local manifest dependency
    manifest=$(swift package --disable-sandbox dump-package --package-path "$1")
    echo "$manifest"
    @jq@ --raw-output '.dependencies[] | select(.fileSystem) | .fileSystem[].path' <<< "$manifest" | while read -r dependency; do
        swiftpmDumpLocalPackages "$dependency"
    done
}

swiftpmUnpackDeps() {
    if [ -n "$swiftpmDeps" ]; then
       echo "Unpacking SwiftPM dependencies"

       # Set up `workspace-state.json`. Local packages must be added now, or SwiftPM will try to fetch their dependencies.
       mkdir -p "$NIX_BUILD_TOP/$sourceRoot/.build"
       @jq@ --sort-keys --arg build "$NIX_BUILD_TOP/$sourceRoot/.build" \
         --slurpfile manifests <(swiftpmDumpLocalPackages "$NIX_BUILD_TOP/$sourceRoot") '
           {
               "object": {
                   "artifacts": (.object.artifacts | map(.path = $build + "/" + .path)),
                   "dependencies": (
                       .object.dependencies
                       + ([ $manifests[] | .dependencies[] | select(.fileSystem) | .[][] |
                           {
                               "basedOn": null,
                               "packageRef": {
                                 "identity": .identity,
                                 "kind": "fileSystem",
                                 "location": .path,
                                 "name": .path | sub("\\.git$"; "") | split("/")[-1]
                               },
                               "state": {
                                 "name": "fileSystem",
                                 "path": .path
                               },
                               "subpath": .identity
                           }
                       ] | unique_by(.packageRef.identity))
                   ),
               "prebuilts": [ ],
           },
           "version": 7
         }
       ' "$swiftpmDeps/workspace-state.json" \
         > "$NIX_BUILD_TOP/$sourceRoot/.build/workspace-state.json~"
       mv "$NIX_BUILD_TOP/$sourceRoot/.build/workspace-state.json~" "$NIX_BUILD_TOP/$sourceRoot/.build/workspace-state.json"

       # The closest thing to vendoring SwiftPM supports is setting up a dependencies as edited at `Packages`.
       ln -s "$swiftpmDeps/Packages" "$NIX_BUILD_TOP/$sourceRoot/Packages"

       # SwiftPM writes to `.build/artifacts`
       if [ -d "$swiftpmDeps/artifacts" ]; then
           cp -rL --no-preserve=mode "$swiftpmDeps/artifacts" "$NIX_BUILD_TOP/$sourceRoot/.build/artifacts"
       fi
    fi
}

appendToVar postUnpackHooks swiftpmUnpackDeps

