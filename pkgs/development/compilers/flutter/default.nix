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
    version = "3.10.5";
    engineVersion = "45f6e009110df4f34ec2cf99f63cf73b71b7a420";
    dartVersion = "3.0.5";
    dartHash = {
      x86_64-linux = "sha256-UVVwPFk0qsKNR4JZMOGSGh1T482MN/8Xp4MZ3SA3C28=";
      aarch64-linux = "sha256-phzaFfrv7qbZOOhPq92q39R6mr5vFeBqEmYDU7e7lZQ=";
      x86_64-darwin = "sha256-4gJ659bNzs2lfI1LRwFACgu/ttkj+3xIrqLijju+CaI=";
      aarch64-darwin = "sha256-RJt+muq5IrcAhVLYEgdbVygcY1oB7tnVCN+iqktC+6c=";
    };
    flutterHash = rec {
      x86_64-linux = "sha256-lLppUQzu+fl81TMYSPD+HA83BqeIg7bXpURyo49NPwI=";
      aarch64-linux = x86_64-linux;
      x86_64-darwin = "sha256-1ZC5aCoGVBCeTSsu/ZEl1v53lLnzulx8Ya6YXvo4yIY=";
      aarch64-darwin = "sha256-TCMempLjO47IbP5MAZVHlXXvNaURGo+EbaL0K8e27wU=";
    };
    patches = flutter3Patches;
  };

  v37 = mkFlutter {
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
    patches = flutter3Patches;
  };
}
