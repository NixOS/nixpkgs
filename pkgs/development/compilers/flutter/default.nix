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
    version = "3.13.8";
    engineVersion = "767d8c75e898091b925519803830fc2721658d07";
    dartVersion = "3.1.4";
    dartHash = {
      x86_64-linux = "sha256-42wrqzjRcFDWw2aEY6+/faX+QE9PA8FmRWP4M/NkgBE=";
      aarch64-linux = "sha256-/tWWWwTOgXHbwzotc7ZDDZa8+cbX6NODGYrjLK9gPPg=";
      x86_64-darwin = "sha256-BchKowKd6BscVuk/dXibcQzdFkW9//GDfll77mHEI4M=";
      aarch64-darwin = "sha256-9yrx09vYrOTmdqkfJI7mfh7DI1/rg67tPlf82m5+iKI=";
    };
    flutterHash = rec {
      x86_64-linux = "sha256-ouI1gjcynSQfPTnfTVXQ4r/NEDdhmzUsKdcALLRiCbg=";
      aarch64-linux = x86_64-linux;
      x86_64-darwin = "sha256-k6KNazP/I71zG5mbx3iEtXBJ8EZi9Qq+7PgL/HAJrgE=";
      aarch64-darwin = "sha256-Duvw8EqrGb3PmBHBH/prZjyij2xJd9sLkNfPRYpC0pQ=";
    };
    patches = flutter3Patches;
  };
}
