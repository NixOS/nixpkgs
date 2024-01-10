{ callPackage, fetchzip, fetchFromGitHub, dart, lib, stdenv }:
let
  mkCustomFlutter = args: callPackage ./flutter.nix args;
  wrapFlutter = flutter: callPackage ./wrapper.nix { inherit flutter; };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  mkFlutter =
    { version
    , engineVersion
    , dartVersion
    , flutterHash
    , dartHash
    , patches
    , pubspecLockFile
    , vendorHash
    , depsListFile
    }:
    let
      args = {
        inherit version engineVersion patches pubspecLockFile vendorHash depsListFile;

        dart = dart.override {
          version = dartVersion;
          sources = {
            "${dartVersion}-x86_64-linux" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
              sha256 = dartHash.x86_64-linux;
            };
            "${dartVersion}-aarch64-linux" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-arm64-release.zip";
              sha256 = dartHash.aarch64-linux;
            };
            "${dartVersion}-x86_64-darwin" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-macos-x64-release.zip";
              sha256 = dartHash.x86_64-darwin;
            };
            "${dartVersion}-aarch64-darwin" = fetchzip {
              url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-macos-arm64-release.zip";
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
    (mkCustomFlutter args).overrideAttrs (prev: next: {
      passthru = next.passthru // rec {
        inherit wrapFlutter mkCustomFlutter mkFlutter;
        buildFlutterApplication = callPackage ../../../build-support/flutter {
          # Package a minimal version of Flutter that only uses Linux desktop release artifacts.
          flutter = (wrapFlutter (mkCustomFlutter args)).override {
            supportedTargetPlatforms = [ "universal" "linux" ];
          };
        };
      };
    });

  flutter3Patches = getPatches ./patches/flutter3;
in
{
  inherit wrapFlutter;
  stable = mkFlutter {
    version = "3.13.8";
    engineVersion = "767d8c75e898091b925519803830fc2721658d07";
    dartVersion = "3.1.4";
    dartHash = {
      x86_64-linux = "sha256-42wrqzjRcFDWw2aEY6+/faX+QE9PA8FmRWP4M/NkgBE=";
      aarch64-linux = "sha256-/tWWWwTOgXHbwzotc7ZDDZa8+cbX6NODGYrjLK9gPPg=";
      x86_64-darwin = "sha256-BchKowKd6BscVuk/dXibcQzdFkW9//GDfll77mHEI4M=";
      aarch64-darwin = "sha256-9yrx09vYrOTmdqkfJI7mfh7DI1/rg67tPlf82m5+iKI=";
    };
    flutterHash = "sha256-00G030FvZZTsdf9ruFs9jdIHcC5h+xpp4NlmL64qVZA=";
    patches = flutter3Patches;
    pubspecLockFile = ./lockfiles/stable/pubspec.lock;
    vendorHash = "sha256-lsFOvvmhszBcFb9XvabpqfL2Ek4wjhmB0OrcWUOURFQ=";
    depsListFile = ./lockfiles/stable/deps.json;
  };
}
