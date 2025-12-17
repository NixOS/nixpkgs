{
  useNixpkgsEngine ? false,
  callPackage,
  fetchzip,
  fetchFromGitHub,
  dart,
  lib,
  stdenv,
  runCommand,
}:
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
    }:
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

        dart =
          let
            dartChannel = if lib.strings.hasSuffix ".beta" dartVersion then "beta" else "stable";
          in
          dart.override {
            version = dartVersion;
            sources = {
              "${dartVersion}-x86_64-linux" = fetchzip {
                url = "https://storage.googleapis.com/dart-archive/channels/${dartChannel}/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
                hash = dartHash.x86_64-linux;
              };
              "${dartVersion}-aarch64-linux" = fetchzip {
                url = "https://storage.googleapis.com/dart-archive/channels/${dartChannel}/release/${dartVersion}/sdk/dartsdk-linux-arm64-release.zip";
                hash = dartHash.aarch64-linux;
              };
              "${dartVersion}-x86_64-darwin" = fetchzip {
                url = "https://storage.googleapis.com/dart-archive/channels/${dartChannel}/release/${dartVersion}/sdk/dartsdk-macos-x64-release.zip";
                hash = dartHash.x86_64-darwin;
              };
              "${dartVersion}-aarch64-darwin" = fetchzip {
                url = "https://storage.googleapis.com/dart-archive/channels/${dartChannel}/release/${dartVersion}/sdk/dartsdk-macos-arm64-release.zip";
                hash = dartHash.aarch64-darwin;
              };
            };
          };
        src =
          let
            source = fetchFromGitHub {
              owner = "flutter";
              repo = "flutter";
              tag = version;
              hash = flutterHash;
            };
          in
          (
            if lib.versionAtLeast version "3.32" then
              # # Could not determine engine revision
              (runCommand source.name { } ''
                cp --recursive ${source} $out
                chmod +w $out/bin
                mkdir $out/bin/cache
                cp $out/bin/internal/engine.version $out/bin/cache/engine.stamp
                touch $out/bin/cache/engine.realm
              '')
            else
              source
          );
      };
    in
    (mkCustomFlutter args).overrideAttrs (
      prev: next: {
        passthru = next.passthru // {
          inherit wrapFlutter mkCustomFlutter mkFlutter;
          buildFlutterApplication = callPackage ./build-support/build-flutter-application.nix {
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
  inherit wrapFlutter mkFlutter;
}
// lib.optionalAttrs (betaFlutterVersions != { }) {
  beta = flutterVersions.${lib.last (lib.naturalSort (builtins.attrNames betaFlutterVersions))};
}
// lib.optionalAttrs (stableFlutterVersions != { }) {
  stable = flutterVersions.${lib.last (lib.naturalSort (builtins.attrNames stableFlutterVersions))};
}
