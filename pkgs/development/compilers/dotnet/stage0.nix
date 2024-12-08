{
  stdenv,
  callPackage,
  lib,
  writeShellScript,
  mkNugetDeps,
  nix,
  cacert,
  nuget-to-nix,
  nixfmt-rfc-style,
  dotnetCorePackages,
  xmlstarlet,
  patchNupkgs,
  symlinkJoin,

  baseName ? "dotnet",
  releaseManifestFile,
  tarballHash,
  depsFile,
  fallbackTargetPackages,
  bootstrapSdk,
}:

let
  mkPackages = callPackage ./packages.nix;
  mkVMR = callPackage ./vmr.nix;

  sdkPackages = symlinkJoin {
    name = "${bootstrapSdk.name}-packages";
    paths = map (
      p:
      p.override {
        installable = true;
      }
    ) bootstrapSdk.packages;
  };

  vmr =
    (mkVMR {
      inherit
        baseName
        releaseManifestFile
        tarballHash
        bootstrapSdk
        ;
    }).overrideAttrs
      (old: rec {
        prebuiltPackages = mkNugetDeps {
          name = "dotnet-vmr-deps";
          sourceFile = depsFile;
          installable = true;
        };

        nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
          xmlstarlet
          patchNupkgs
        ];

        postPatch =
          old.postPatch or ""
          + ''
            xmlstarlet ed \
              --inplace \
              -s //Project -t elem -n Import \
              -i \$prev -t attr -n Project -v "${./patch-restored-packages.proj}" \
              src/*/Directory.Build.targets
          '';

        postConfigure =
          old.postConfigure or ""
          + ''
            [[ ! -v prebuiltPackages ]] || \
              ln -sf "$prebuiltPackages"/share/nuget/source/*/*/*.nupkg prereqs/packages/prebuilt/
            ln -sf "${sdkPackages}"/share/nuget/source/*/*/*.nupkg prereqs/packages/prebuilt/
          '';

        buildFlags =
          old.buildFlags
          ++ lib.optionals (lib.versionAtLeast old.version "9") [
            # We need to set this as long as we have something in deps.nix. Currently
            # that's the portable ilasm/ildasm which aren't in the centos sourcebuilt
            # artifacts.
            "-p:SkipErrorOnPrebuilts=true"
          ];

        passthru = old.passthru or { } // {
          fetch-deps =
            let
              inherit (vmr) targetRid updateScript;
              otherRids = lib.remove targetRid (
                map (system: dotnetCorePackages.systemToDotnetRid system) vmr.meta.platforms
              );

              pkg = vmr.overrideAttrs (old: {
                nativeBuildInputs = old.nativeBuildInputs ++ [
                  nix
                  cacert
                  nuget-to-nix
                  nixfmt-rfc-style
                ];
                postPatch =
                  old.postPatch or ""
                  + ''
                    xmlstarlet ed \
                      --inplace \
                      -s //Project -t elem -n Import \
                      -i \$prev -t attr -n Project -v "${./record-downloaded-packages.proj}" \
                      repo-projects/Directory.Build.targets
                    # make nuget-client use the standard arcade package-cache dir, which
                    # is where we scan for dependencies
                    xmlstarlet ed \
                      --inplace \
                      -s //Project -t elem -n ItemGroup \
                      -s \$prev -t elem -n EnvironmentVariables \
                      -i \$prev -t attr -n Include -v 'NUGET_PACKAGES=$(ProjectDirectory)artifacts/sb/package-cache/' \
                      repo-projects/nuget-client.proj
                  '';
                buildFlags = [ "--online" ] ++ old.buildFlags;
                prebuiltPackages = null;
              });

              drv = builtins.unsafeDiscardOutputDependency pkg.drvPath;
            in
            writeShellScript "fetch-dotnet-sdk-deps" ''
              ${nix}/bin/nix-shell --pure --run 'source /dev/stdin' "${drv}" << 'EOF'
              set -e

              tmp=$(mktemp -d)
              trap 'rm -fr "$tmp"' EXIT

              HOME=$tmp/.home
              cd "$tmp"

              phases="''${prePhases[*]:-} unpackPhase patchPhase ''${preConfigurePhases[*]:-} \
                configurePhase ''${preBuildPhases[*]:-} buildPhase checkPhase" \
                genericBuild

              depsFiles=(./src/*/deps.nix)

              cat $(nix-build ${toString ./combine-deps.nix} \
                --arg list "[ ''${depsFiles[*]} ]" \
                --argstr baseRid ${targetRid} \
                --arg otherRids '${lib.generators.toPretty { multiline = false; } otherRids}' \
                ) > deps.nix
              nixfmt deps.nix

              mv deps.nix "${toString prebuiltPackages.sourceFile}"
              EOF
            '';
        };
      });
in
mkPackages { inherit baseName vmr; }
