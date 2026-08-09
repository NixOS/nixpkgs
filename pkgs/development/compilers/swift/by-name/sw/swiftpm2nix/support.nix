{
  lib,
  fetchgit,
  formats,
  jq,
  swiftpmHook,
  swiftpmUnpackHook,
}:
let
  inherit (lib)
    concatStrings
    listToAttrs
    makeOverridable
    mapAttrsToList
    nameValuePair
    ;
  json = formats.json { };
in
rec {

  # Derive a pin file from workspace state.
  mkPinFile =
    workspaceState:
    assert workspaceState.version >= 5 && workspaceState.version <= 6;
    json.generate "Package.resolved" {
      version = 1;
      object.pins = map (dep: {
        package = dep.packageRef.name;
        repositoryURL = dep.packageRef.location;
        state = dep.state.checkoutState;
      }) workspaceState.object.dependencies;
    };

  # Make packaging helpers from swiftpm2nix generated output.
  helpers =
    generated:
    let
      inherit (import generated) workspaceStateFile hashes;
      workspaceState = lib.importJSON workspaceStateFile;
      pinFile = mkPinFile workspaceState;
    in
    rec {

      # Create fetch expressions for dependencies.
      sources = listToAttrs (
        map (
          dep:
          nameValuePair dep.subpath (fetchgit {
            url = dep.packageRef.location;
            rev = dep.state.checkoutState.revision;
            sha256 = hashes.${dep.subpath};
            fetchSubmodules = true;
          })
        ) workspaceState.object.dependencies
      );

      # Configure phase snippet for use in packaging.
      configure = ''
        swiftpmDeps=$NIX_BUILD_TOP/swiftpmDeps
        mkdir -p "$swiftpmDeps/Packages"

        # Rewrite the workspace-state.json to put the packages in edit mode. This is needed for compatibility with
        # `swiftpmUnpackDeps`, which uses edit mode for vendoring.
        ${lib.getExe jq} '
            {
                "object": {
                    "artifacts": .object.artifacts[] // [ ],
                    "dependencies": [ .object.dependencies[] |
                        {
                            "basedOn": .basedOn,
                            "packageRef": .packageRef,
                            "state": {
                                "name": "edited",
                                "path": null
                            },
                            "subpath": .subpath,
                        }
                    ],
                    "prebuilts": [ ],
                },
                "version": 7
            }
        ' < ${workspaceStateFile} > "$swiftpmDeps/workspace-state.json"
      ''
      + concatStrings (
        mapAttrsToList (name: src: ''
          ln -s '${src}' "$swiftpmDeps/Packages/${name}"
        '') sources
      )
      + ''
        swiftpmUnpackDeps

        # Helper that makes a swiftpm dependency mutable by copying the source.
        swiftpmMakeMutable() {
          local checkoutDir=$NIX_BUILD_TOP/$sourceRoot/.build/checkouts
          local orig=$(readlink -f "Packages/$1")

          mkdir -p "$checkoutDir"
          cp -r "$orig" "$checkoutDir/$1"
          chmod -R u+w "$checkoutDir/$1"

          rm "Packages/$1"
          ln -s "$checkoutDir/$1" "Packages/$1"
        }
      '';

    };

}
