{ callPackage, fetchzip, dart, lib, stdenv }:
let
  mkCustomFlutter = args: callPackage ./flutter.nix args;
  wrapFlutter = flutter: callPackage ./wrapper.nix { inherit flutter; };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  mkFlutter = { version, engineVersion, dartVersion, flutterHash, dartHash, patches }:
    let
      args = {
        inherit version engineVersion patches;

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
        src = {
          x86_64-linux = fetchzip {
            url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz";
            sha256 = flutterHash.x86_64-linux;
          };
          aarch64-linux = fetchzip {
            url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz";
            sha256 = flutterHash.aarch64-linux;
          };
          x86_64-darwin = fetchzip {
            url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${version}-stable.zip";
            sha256 = flutterHash.x86_64-darwin;
          };
          aarch64-darwin = fetchzip {
            url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_${version}-stable.zip";
            sha256 = flutterHash.aarch64-darwin;
          };
        }.${stdenv.hostPlatform.system};
      };
    in
    (mkCustomFlutter args).overrideAttrs (prev: next: {
      passthru = next.passthru // rec {
        inherit wrapFlutter mkCustomFlutter mkFlutter;
        buildFlutterApplication = callPackage ../../../build-support/flutter {
          # Package a minimal version of Flutter that only uses Linux desktop release artifacts.
          flutter = (wrapFlutter (mkCustomFlutter args)).override {
            supportsAndroid = false;
            includedEngineArtifacts = {
              common = [ "flutter_patched_sdk_product" ];
              platform.linux = lib.optionals stdenv.hostPlatform.isLinux
                (lib.genAttrs ((lib.optional stdenv.hostPlatform.isx86_64 "x64") ++ (lib.optional stdenv.hostPlatform.isAarch64 "arm64"))
                  (architecture: [ "release" ]));
            };
          };
        };
      };
    });

  flutter3Patches = getPatches ./patches/flutter3;
in
{
  inherit wrapFlutter;
  stable = mkFlutter {
    version = "3.13.4";
    engineVersion = "9064459a8b0dcd32877107f6002cc429a71659d1";
    dartVersion = "3.1.2";
    dartHash = {
      x86_64-linux = "sha256-kriMqIvS/ZPhCR+hDTZReW4MMBYCVzSO9xTuPrJ1cPg=";
      aarch64-linux = "sha256-Fvg9Rr9Z7LYz8MjyzVCZwCzDiWPLDvH8vgD0oDZTksw=";
      x86_64-darwin = "sha256-WL42AYjT2iriVP05Pm7288um+oFwS8o8gU5tCwSOvUM=";
      aarch64-darwin = "sha256-BMbjSNJuh3RC+ObbJf2l6dacv2Hsn2/uygKDrP5EiuU=";
    };
    flutterHash = rec {
      x86_64-linux = "sha256-BPEmO4c3H2bOa+sBAVDz5/qvajobK3YMnBfQWhJUydw=";
      aarch64-linux = x86_64-linux;
      x86_64-darwin = "sha256-BpxeCE9vTnmlIp6OS7BTPkOFptidjXbf2qVOVUAqstY=";
      aarch64-darwin = "sha256-rccuxrE9nzC86uKGL96Etxxs4qMbVXJ1jCn/wjp9WlQ=";
    };
    patches = flutter3Patches;
  };
}
