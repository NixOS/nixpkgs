{ callPackage, fetchzip, dart }:
let
  mkFlutter = { version, patches, dart, src }: callPackage ./flutter.nix { inherit version patches dart src; };
  wrapFlutter = flutter: callPackage ./wrapper.nix { inherit flutter; };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  flutterDrv = { version, dartVersion, hash, dartHash, patches }: mkFlutter {
    inherit version patches;
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
      };
    };
    src = fetchzip {
      url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz";
      sha256 = hash;
    };
  };
  flutter2Patches = getPatches ./patches/flutter2;
  flutter3Patches = getPatches ./patches/flutter3;
in
{
  inherit mkFlutter wrapFlutter flutterDrv flutter3Patches flutter2Patches;
  stable = flutterDrv {
    version = "3.7.12";
    dartVersion = "2.19.6";
    hash = "sha256-5ExDBQXIpoZ5NwS66seY3m9/V8xDiyq/RdzldAyHdEE=";
    dartHash = {
      x86_64-linux = "sha256-4ezRuwhQHVCxZg5WbzU/tBUDvZVpfCo6coDE4K0UzXo=";
      aarch64-linux = "sha256-pYmClIqOo0sRPOkrcF4xQbo0mHlrr1TkhT1fnNyYNck=";
    };
    patches = flutter3Patches;
  };

  v2 = flutterDrv {
    version = "2.10.5";
    dartVersion = "2.16.2";
    hash = "sha256-MxaWvlcCfXN8gsC116UMzqb4LgixHL3YjrGWy7WYgW4=";
    dartHash = {
      x86_64-linux = "sha256-vxKxysg6e3Qxtlp4dLxOZaBtgHGtl7XYd73zFZd9yJc=";
      aarch64-linux = "sha256-ZfpR6fj/a9Bsgrg31Z/uIJaCHIWtcQH3VTTVkDJKkwA=";
    };
    patches = flutter2Patches;
  };
}
