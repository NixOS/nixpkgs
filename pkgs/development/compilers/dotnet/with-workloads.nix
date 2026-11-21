# Compose a .NET SDK with workload packs pre-installed.
#
# Usage:
#   withWorkloads sdk ["wasm-tools"]
#
# Workload packs live in a separate derivation. The SDK overlay links them
# and exports DOTNETSDK_WORKLOAD_PACK_ROOTS for the workload resolver.
sdk: workloadIds:

{
  stdenvNoCC,
  lib,
  buildEnv,
  fetchNupkg,
  callPackage,
  systemToDotnetRid,
  lndir,
}:

let
  mkWrapper = callPackage ./wrapper.nix { };
  hostRid = systemToDotnetRid stdenvNoCC.hostPlatform.system;

  sdkVersion =
    workloadData.featureBands.${sdk.version}
      or (throw "No verified workload data for SDK ${sdk.version}; run pkgs/development/compilers/dotnet/update-workloads.sh ${majorMinor}");

  majorMinor = lib.concatStringsSep "." (lib.take 2 (lib.splitVersion sdk.version));

  # Load the workload data for this SDK band.
  workloadData =
    let
      dataFile = ./workloads/${majorMinor}.nix;
    in
    assert lib.assertMsg (builtins.pathExists dataFile)
      "No workload data for .NET ${majorMinor}. Supported: 10.0, 11.0.";
    import dataFile;

  # Resolve the list of pack keys needed for the requested workloads on this RID.
  ridWorkloads =
    workloadData.workloadPackNames.${hostRid} or (throw "No workload data for RID ${hostRid}");

  resolvedPackKeys = lib.unique (
    lib.concatMap (
      wid:
      ridWorkloads.${wid}
        or (throw "Unknown workload '${wid}'. Available: ${builtins.concatStringsSep ", " (builtins.attrNames ridWorkloads)}")
    ) workloadIds
  );

  # Look up each pack's fetch info from the hash table.
  packInfos = map (key: workloadData.packHashes.${key}) resolvedPackKeys;

  # Fetch each pack as a nupkg and relocate it into the SDK packs layout.
  # fetchNupkg handles download, extraction, signature removal, and native patching.
  mkPack =
    {
      pname,
      version,
      hash,
      kind ? "sdk",
    }:
    let
      nupkg = fetchNupkg {
        inherit pname version hash;
        installable = kind == "library";
      };
    in
    stdenvNoCC.mkDerivation {
      pname = "dotnet-workload-pack-${lib.toLower pname}";
      inherit version;

      dontUnpack = true;

      # Relocate from the NuGet cache layout to the SDK packs layout.
      # fetchNupkg installs to share/nuget/packages/<lower-pname>/<lower-version>/
      # but MSBuild expects share/dotnet/packs/<OriginalCase-pname>/<version>/
      installPhase =
        if kind == "library" then
          ''
            runHook preInstall
            mkdir -p "$out/share/dotnet/library-packs"
            cp "${nupkg}"/share/nuget/source/${lib.toLower pname}/${lib.toLower version}/*.nupkg \
              "$out/share/dotnet/library-packs/"
            runHook postInstall
          ''
        else
          ''
            runHook preInstall
            local packDir="$out/share/dotnet/packs/${pname}/${version}"
            mkdir -p "$packDir"
            cp -r "${nupkg}"/share/nuget/packages/${lib.toLower pname}/${lib.toLower version}/* "$packDir"/
            runHook postInstall
          '';

    };

  packDerivations = map mkPack packInfos;

  # Combine all packs into a single root.
  # Used both in the buildEnv (for MSBuild's direct path lookups) and
  # exposed as WORKLOAD_PACK_ROOTS (for the C# WorkloadResolver).
  workloadPackRoot = buildEnv {
    name = "dotnet-workload-packs-${majorMinor}";
    paths = packDerivations;
    pathsToLink = map (x: "/share/dotnet/${x}") [
      "packs"
      "template-packs"
      "library-packs"
      "tool-packs"
    ];
  };

  # Create the workload installation metadata so `dotnet workload list` works.
  # This goes into the SDK tree via buildEnv.
  workloadMetadata = stdenvNoCC.mkDerivation {
    pname = "dotnet-workload-metadata";
    version = sdk.version;

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      local metaDir="$out/share/dotnet/metadata/workloads/${sdkVersion}"
      mkdir -p "$metaDir/InstalledWorkloads"

      ${lib.concatMapStringsSep "\n" (wid: ''
        touch "$metaDir/InstalledWorkloads/${wid}"
      '') workloadIds}

      # Mark as file-based install so `dotnet workload list` doesn't warn
      # about unverified workloads.
      echo "FileBased" > "$metaDir/InstallType"

      runHook postInstall
    '';

    dontFixup = true;
  };

in
assert lib.assertMsg (workloadIds != [ ]) "withWorkloads: must specify at least one workload ID";
assert lib.assertMsg (
  sdk ? unwrapped
) "withWorkloads: expected a wrapped SDK (with .unwrapped attribute)";
mkWrapper "sdk" (
  (buildEnv {
    name = "dotnet-sdk-with-workloads-${sdk.version}";
    paths = [
      sdk.unwrapped
      workloadMetadata
      workloadPackRoot
    ];
    pathsToLink = map (x: "/share/dotnet/${x}") [
      "host"
      "library-packs"
      "metadata"
      "packs"
      "sdk"
      "sdk-manifests"
      "shared"
      "template-packs"
      "templates"
      "tool-packs"
    ];
    ignoreCollisions = true;
    nativeBuildInputs = [ lndir ];
    postBuild = ''
      # SDK directory symlinks make MSBuild resolve NetCoreRoot to the bare SDK,
      # hiding the workload library feed. Keep files linked, but materialize directories.
      sdkDir="$out/share/dotnet/sdk/${sdk.version}"
      unlink "$sdkDir"
      mkdir "$sdkDir"
      lndir -silent "${sdk.unwrapped}/share/dotnet/sdk/${sdk.version}" "$sdkDir"
      # Managed entry points also determine the CLI and MSBuild base directories.
      for entryPoint in dotnet.dll MSBuild.dll; do
        unlink "$sdkDir/$entryPoint"
        cp "${sdk.unwrapped}/share/dotnet/sdk/${sdk.version}/$entryPoint" "$sdkDir/"
      done
      if [[ -e "$sdkDir/MSBuild" ]]; then
        unlink "$sdkDir/MSBuild"
        cp "${sdk.unwrapped}/share/dotnet/sdk/${sdk.version}/MSBuild" "$sdkDir/"
      fi
      mkdir -p "$out"/share/dotnet
      cp "${sdk.unwrapped}"/share/dotnet/dotnet "$out"/share/dotnet
      cp -R "${sdk.unwrapped}"/nix-support "$out"/ 2>/dev/null || true
      mkdir -p "$out"/bin
      ln -s "$out"/share/dotnet/dotnet "$out"/bin/dotnet

      # Remove the userlocal sentinel — it tells the SDK to look in ~/.dotnet/
      # for workloads instead of DOTNET_ROOT. Since we pre-install workloads
      # into the store, we want the SDK to find them here.
      find "$out"/share/dotnet/metadata -name userlocal -delete 2>/dev/null || true
    '';

    passthru = {
      pname = "dotnet-sdk";
      inherit (sdk)
        version
        icu
        packages
        targetPackages
        ;
      inherit (sdk.unwrapped) hasILCompiler;
      inherit (sdk) hasCrossTargetBug;
      runtime = sdk.runtime or null;
      aspnetcore = sdk.aspnetcore or null;
      inherit workloadIds workloadPackRoot;
    };

    meta = sdk.meta // {
      description = "${
        sdk.meta.description or "dotnet"
      } (with workloads: ${builtins.concatStringsSep ", " workloadIds})";
    };
  }).overrideAttrs
    {
      propagatedSandboxProfile = toString (sdk.__propagatedSandboxProfile or [ ]);
    }
)
