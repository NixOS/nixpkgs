# Fetches a package based on its metadata from `Package.resolved`
{
  lib,
  cacert,
  jq,
  nix,
  prefetch-swiftpm-deps,
  runCommand,
  stdenvNoCC,
}:

{
  name ? if args ? pname && args ? version then "${args.pname}-${args.version}" else "swiftpm-deps",
  hash ? (throw "fetchSwiftPMDeps requires a `hash` value to be set for ${name}"),
  nativeBuildInputs ? [ ],
  ...
}@args:

let
  removedArgs = [
    "name"
    "pname"
    "version"
    "nativeBuildInputs"
    "hash"
  ];

  vendorStaging = stdenvNoCC.mkDerivation (
    {
      name = "${name}-vendor-staging";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      strictDeps = true;

      nativeBuildInputs = [
        cacert
        jq
        prefetch-swiftpm-deps
      ]
      ++ nativeBuildInputs;

      buildPhase = ''
        runHook preBuild

        mkdir -p "$out"
        prefetch-swiftpm-deps Package.resolved "$out"

        runHook postBuild
      '';

      dontConfigure = true;
      dontInstall = true;
      dontFixup = true;

      outputHash = hash;
      outputHashAlgo = if hash == "" then "sha256" else null;
      outputHashMode = "recursive";

      __structuredAttrs = true;
    }
    // builtins.removeAttrs args removedArgs
  );
in

# `fetchSwiftPMDeps` splits the workspace-state generation into a separate, non-FOD derivation in case the format
# of the file ever changes or in case we have to do additional processing due to changes in SwiftPM.
runCommand "${name}-vendor"
  {
    inherit vendorStaging;
    nativeBuildInputs = [ jq ];
  }
  ''
    mkdir -p "$out"

    # SwiftPM uses workspace-state.json to determine whether it needs to fetch dependencies.
    # Generate it to prevent that from happening.
    jq --compact-output --sort-keys '
        {
            "object": {
                "artifacts": [ ],
                "dependencies": [ .pins[] |
                    {
                        "basedOn": {
                            "basedOn": null,
                            "packageRef": {
                                "identity": .identity,
                                "kind": .kind,
                                "location": .location,
                                "name": .location | sub("\\.git$"; "") | split("/")[-1]
                            },
                            "state": {
                                "checkoutState": .state,
                                "name": "sourceControlCheckout"
                            },
                            "subpath": .location | sub("\\.git$"; "") | split("/")[-1]
                        },
                        "packageRef": {
                            "identity": .identity,
                            "kind": .kind,
                            "location": .location,
                            "name": .location | sub("\\.git$"; "") | split("/")[-1]
                        },
                        "state": {
                            "name": "edited",
                            "path": null
                        },
                        "subpath": .location | sub("\\.git$"; "") | split("/")[-1]
                    }
                ],
                "prebuilts": [ ]
            },
            "version": 7
        }
    ' < "$vendorStaging/Package.resolved" > "$out/workspace-state.json"

    # Symlink the packages from the staging area. There’s no reason to waste space copying them.
    ln -s "$vendorStaging/Packages" "$out/Packages"
  ''
