{
  useNixpkgsEngine ? false,
  callPackage,
  fetchzip,
  fetchFromGitHub,
  dart,
  lib,
  stdenv,
}@args:
let
  mkCustomFlutter = args: callPackage ./flutter.nix args;
  wrapFlutter = flutter: callPackage ./wrapper.nix { inherit flutter; };
  getPatches =
    dir:
    let
      files = builtins.attrNames (builtins.readDir dir);
    in
    if (builtins.pathExists dir) then map (f: dir + ("/" + f)) files else [ ];
  mkFlutter =
    {
      version,
      engineVersion,
      engineSwiftShaderHash,
      engineSwiftShaderRev,
      engineHashes,
      enginePatches,
      dartVersion,
      flutterHash,
      dartHash,
      patches,
      pubspecLock,
      artifactHashes,
      channel,
    }@fargs:
    let
      args = {
        inherit
          version
          engineVersion
          engineSwiftShaderRev
          engineSwiftShaderHash
          engineHashes
          enginePatches
          patches
          pubspecLock
          artifactHashes
          useNixpkgsEngine
          channel
          ;

        dart = dart.override {
          version = dartVersion;
          sources = {
            "${dartVersion}-x86_64-linux" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/${channel}/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
              sha256 = dartHash.x86_64-linux;
            };
            "${dartVersion}-aarch64-linux" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/${channel}/release/${dartVersion}/sdk/dartsdk-linux-arm64-release.zip";
              sha256 = dartHash.aarch64-linux;
            };
            "${dartVersion}-x86_64-darwin" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/${channel}/release/${dartVersion}/sdk/dartsdk-macos-x64-release.zip";
              sha256 = dartHash.x86_64-darwin;
            };
            "${dartVersion}-aarch64-darwin" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/${channel}/release/${dartVersion}/sdk/dartsdk-macos-arm64-release.zip";
              sha256 = dartHash.aarch64-darwin;
            };
          };
        };
        src = fetchFromGitHub {
          owner = "flutter";
          repo = "flutter";
          rev = version;
          hash = flutterHash;
        };
      };
    in
    (mkCustomFlutter args).overrideAttrs (
      prev: next: {
        passthru = next.passthru // rec {
          inherit wrapFlutter mkCustomFlutter mkFlutter;
          buildFlutterApplication = callPackage ../../../build-support/flutter {
            flutter = wrapFlutter (mkCustomFlutter args);
          };
        };
      }
    );

  flutterVersions = lib.mapAttrs' (
    version: _:
    let
      versionDir = ./versions + "/${version}";
      data = lib.importJSON (versionDir + "/data.json");
    in
    lib.nameValuePair "v${version}" (
      wrapFlutter (
        mkFlutter (
          {
            patches = (getPatches ./patches) ++ (getPatches (versionDir + "/patches"));
            enginePatches = (getPatches ./engine/patches) ++ (getPatches (versionDir + "/engine/patches"));
          }
          // data
        )
      )
    )
  ) (builtins.readDir ./versions);

  stableFlutterVersions = lib.attrsets.filterAttrs (_: v: v.channel == "stable") flutterVersions;
  betaFlutterVersions = lib.attrsets.filterAttrs (_: v: v.channel == "beta") flutterVersions;
in
flutterVersions
// {
  beta = flutterVersions.${lib.last (lib.naturalSort (builtins.attrNames betaFlutterVersions))};
  stable = flutterVersions.${lib.last (lib.naturalSort (builtins.attrNames stableFlutterVersions))};
  inherit wrapFlutter mkFlutter;
}
