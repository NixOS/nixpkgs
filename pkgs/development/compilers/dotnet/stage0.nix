{ stdenv
, stdenvNoCC
, callPackage
, lib
, writeShellScript
, pkgsBuildHost
, mkNugetDeps
, nix
, cacert
, nuget-to-nix
, dotnetCorePackages
, xmlstarlet

, releaseManifestFile
, tarballHash
, depsFile
, bootstrapSdk
}:

let
  mkPackages = callPackage ./packages.nix;
  mkVMR = callPackage ./vmr.nix;

  dotnetSdk = pkgsBuildHost.callPackage bootstrapSdk {};

  patchNupkgs = pkgsBuildHost.callPackage ./patch-nupkgs.nix {};

  deps = mkNugetDeps {
    name = "dotnet-vmr-deps";
    sourceFile = depsFile;
  };

  vmr = (mkVMR {
    inherit releaseManifestFile tarballHash dotnetSdk;
  }).overrideAttrs (old: rec {
    prebuiltPackages = mkNugetDeps {
      name = "dotnet-vmr-deps";
      sourceFile = depsFile;
    };

    nativeBuildInputs =
      old.nativeBuildInputs or []
      ++ [ xmlstarlet ]
      ++ lib.optional stdenv.isLinux patchNupkgs;

    postPatch = old.postPatch or "" + lib.optionalString stdenv.isLinux ''
      xmlstarlet ed \
        --inplace \
        -s //Project -t elem -n Import \
        -i \$prev -t attr -n Project -v "${./patch-restored-packages.proj}" \
        src/*/Directory.Build.targets
    '';

    postConfigure = old.postConfigure or "" + ''
      [[ ! -v prebuiltPackages ]] || ln -sf "$prebuiltPackages"/* prereqs/packages/prebuilt/
    '';

    buildFlags =
      old.buildFlags
      ++ lib.optionals (lib.versionAtLeast old.version "9") [
        # We need to set this as long as we have something in deps.nix. Currently
        # that's the portable ilasm/ildasm which aren't in the centos sourcebuilt
        # artifacts.
        "-p:SkipErrorOnPrebuilts=true"
      ];

    passthru = old.passthru or {} // { fetch-deps =
      let
        inherit (vmr) targetRid updateScript;
        otherRids =
          lib.remove targetRid (
            map (system: dotnetCorePackages.systemToDotnetRid system)
              vmr.meta.platforms);

        pkg = vmr.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [
            nix
            cacert
            (nuget-to-nix.override { dotnet-sdk = dotnetSdk; })
          ];
          postPatch = old.postPatch or "" + ''
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
            ) > "${toString prebuiltPackages.sourceFile}"
          EOF
        '';
    };
  });
in mkPackages { inherit vmr; }
