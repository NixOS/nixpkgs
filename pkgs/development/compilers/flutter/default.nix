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
  stable =  mkFlutter {
  version = "3.16.5";
  engineVersion = "3f3e560236539b7e2702f5ac790b2a4691b32d49";
  dartVersion = "3.2.3";
  dartHash = {
    "x86_64-linux" = "sha256-mPR7HS8GdJD37FmBPYoFPUo+jHlSVz2epzYu1dX4WmA=";
    "aarch64-linux" = "sha256-2Qa+VVbV5vdcuKn75+2Xkk9vQ0ycBVv+mRjSnMJTB8o=";
    "x86_64-darwin" = "sha256-KU1/2wLOIIsb6K4wFy4/4sxTc0oYVSgZWa4Mi01cr/Y=";
    "aarch64-darwin" = "sha256-Y2lBBAATz46PI+bJ3LUSOLQA7LVITNAd/Ti+jz048cw=";
  };
  flutterHash = "sha256-uPCoOWv3Esl01mq39GIQtIF+lF1/98jm9JJod6Zaivs=";
  patches = flutter3Patches;
  pubspecLockFile = ./lockfiles/stable/pubspec.lock;
  vendorHash = "sha256-5LcMB7jh+BEllC2lDlHlA+xcTiFT+o2QS11c1wFX7Cw=";
  depsListFile = ./lockfiles/stable/deps.json;
};
}
