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

  flutter2Patches = getPatches ./patches/flutter2;
  flutter3Patches = getPatches ./patches/flutter3;
  flutter37Patches = getPatches ./patches/flutter37;
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

  v37 = let flutter = mkFlutter {
    version = "3.7.12";
    engineVersion = "1a65d409c7a1438a34d21b60bf30a6fd5db59314";
    dartVersion = "2.19.6";
    dartHash = {
      x86_64-linux = "sha256-4ezRuwhQHVCxZg5WbzU/tBUDvZVpfCo6coDE4K0UzXo=";
      aarch64-linux = "sha256-pYmClIqOo0sRPOkrcF4xQbo0mHlrr1TkhT1fnNyYNck=";
      x86_64-darwin = "sha256-tuIQhIOX2ub0u99CW/l7nCya9YVNokCZNgbVFqO4ils=";
      aarch64-darwin = "sha256-Oe8/0ygDN3xf5/2I3N/OBzF0bps7Mg0K2zJKj+E9Nak=";
    };
    flutterHash = rec {
      x86_64-linux = "sha256-5ExDBQXIpoZ5NwS66seY3m9/V8xDiyq/RdzldAyHdEE=";
      aarch64-linux = x86_64-linux;
      x86_64-darwin = "sha256-cJF8KB9fNb3hTZShDAPsMmr1neRdIMLvIl/m2tpzwQs=";
      aarch64-darwin = "sha256-yetEE65UP2Wh9ocx7nClQjYLHO6lIbZPay1+I2tDSM4=";
    };
    patches = flutter37Patches;
  }; in flutter // { meta = flutter.meta // { knownVulnerabilities = [ "CVE-2023-4863 WebP Vulnerability" ]; }; };

  v2 = let flutter = mkFlutter {
    version = "2.10.5";
    engineVersion = "57d3bac3dd5cb5b0e464ab70e7bc8a0d8cf083ab";
    dartVersion = "2.16.2";
    dartHash = {
      x86_64-linux = "sha256-vxKxysg6e3Qxtlp4dLxOZaBtgHGtl7XYd73zFZd9yJc=";
      aarch64-linux = "sha256-ZfpR6fj/a9Bsgrg31Z/uIJaCHIWtcQH3VTTVkDJKkwA=";
      # these weren't supported previously
      x86_64-darwin = lib.fakeHash;
      aarch64-darwin = lib.fakeHash;
    };
    flutterHash = rec {
      x86_64-linux = "sha256-MxaWvlcCfXN8gsC116UMzqb4LgixHL3YjrGWy7WYgW4=";
      aarch64-linux = x86_64-linux;
      # these weren't supported previously
      x86_64-darwin = lib.fakeHash;
      aarch64-darwin = lib.fakeHash;
    };
    patches = flutter2Patches;
  }; in flutter // { meta = flutter.meta // { platforms = [ "x86_64-linux" "aarch64-linux" ]; knownVulnerabilities = [ "CVE-2023-4863 WebP Vulnerability" ]; }; };
}
