# shellcheck shell=bash

swiftpmUnpackDeps() {
    if [ -n "$swiftpmDeps" ]; then
       echo "Unpacking SwiftPM dependencies"

       # Set up `workspace-state.json`. Local packages must be added now, or SwiftPM will try to fetch their dependencies.
       mkdir -p "$NIX_BUILD_TOP/$sourceRoot/.build"
       @jq@ -s --sort-keys '
           {
               "object": {
                   "artifacts": [ ],
                   "dependencies": (
                       (.[0] | .object.dependencies)
                       + [ .[1] | .dependencies[] | select(.fileSystem) | .[][] |
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
                       ]
                   ),
               "prebuilts": [ ],
           },
           "version": 7
         }
       ' "$swiftpmDeps/workspace-state.json" <(swift-package dump-package --package-path "$NIX_BUILD_TOP/$sourceRoot") \
         > "$NIX_BUILD_TOP/$sourceRoot/.build/workspace-state.json~"
       mv "$NIX_BUILD_TOP/$sourceRoot/.build/workspace-state.json~" "$NIX_BUILD_TOP/$sourceRoot/.build/workspace-state.json"

       # The closest thing to vendoring SwiftPM supports is setting up a dependencies as edited at `Packages`.
       ln -s "$swiftpmDeps/Packages" "$NIX_BUILD_TOP/$sourceRoot/Packages"
    fi
}

appendToVar postUnpackHooks swiftpmUnpackDeps

