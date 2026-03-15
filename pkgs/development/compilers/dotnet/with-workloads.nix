# Compose a .NET SDK with workload packs pre-installed.
#
# Usage:
#   withWorkloads sdk ["wasm-tools"]
#
# Workload packs are installed into a separate derivation and made available
# to the SDK via the WORKLOAD_PACK_ROOTS environment variable. This avoids
# merging packs into the SDK tree and the expensive `cp -Lr` symlink
# resolution that would otherwise be needed for MSBuild to find them.
sdk: workloadIds:

{
  stdenv,
  stdenvNoCC,
  lib,
  buildEnv,
  autoPatchelfHook,
  fetchurl,
  unzip,
  callPackage,
  systemToDotnetRid,
  icu,
  zlib,
  openssl,
}:

let
  mkWrapper = callPackage ./wrapper.nix { };
  hostRid = systemToDotnetRid stdenvNoCC.hostPlatform.system;

  # Determine the SDK band from the SDK version.
  # SDK version like "9.0.114" -> band "9.0.100"
  sdkVersion =
    let
      v = sdk.version;
      parts = lib.splitVersion v;
      major = builtins.elemAt parts 0;
      minor = builtins.elemAt parts 1;
      patch = builtins.elemAt parts 2;
      # Band = major.minor.X00 where X is the first digit of patch
      bandPatch = builtins.substring 0 1 patch + "00";
    in
    "${major}.${minor}.${bandPatch}";

  majorMinor = lib.concatStringsSep "." (lib.take 2 (lib.splitVersion sdk.version));

  # Load the workload data for this SDK band.
  workloadData =
    let
      dataFile = ./workloads/${majorMinor}.nix;
    in
    assert lib.assertMsg (builtins.pathExists dataFile)
      "No workload data for .NET ${majorMinor}. Supported: 8.0, 9.0, 10.0, 11.0.";
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

  # Fetch each pack as a nupkg and install it into the packs root layout.
  mkPack =
    {
      pname,
      version,
      hash,
    }:
    stdenvNoCC.mkDerivation {
      pname = "dotnet-workload-pack-${lib.toLower pname}";
      inherit version;

      src = fetchurl {
        name = "${lib.toLower pname}.${lib.toLower version}.nupkg";
        url = "https://www.nuget.org/api/v2/package/${pname}/${version}";
        inherit hash;
      };

      nativeBuildInputs = [ unzip ] ++ lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

      buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
        stdenv.cc.cc
        icu
        zlib
        openssl
      ];

      # Only patchelf host-platform binaries (tools/).
      # runtimes/*/native/ contains target-platform binaries (e.g. Android, iOS)
      # that can't and shouldn't be patched for the build host.
      autoPatchelfIgnoreMissingDeps = true;

      sourceRoot = ".";

      unpackPhase = ''
        mkdir source
        unzip -nqd source "$src"
      '';

      installPhase = ''
        runHook preInstall

        local packDir="$out/share/dotnet/packs/${pname}/${version}"
        mkdir -p "$packDir"
        cp -r source/* "$packDir"/
        chmod -R +w "$packDir"

        # Remove signature files
        rm -rf "$packDir"/.signature.p7s

        # Mark native binaries as executable
        local dir
        for dir in "$packDir"/tools "$packDir"/runtimes/*/native; do
          [[ -d "$dir" ]] && chmod -R +x "$dir" || true
        done

        runHook postInstall
      '';

      dontPatchELF = true;
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
    postBuild = ''
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
