{ callPackage, fetchurl, dart }:
let
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  mkFlutter = { version, pname ? "flutter", dartVersion, hash, dartHash, patches, usePreload ? true}: callPackage (import ./flutter.nix {
    inherit version pname patches mkFlutter usePreload;
    dart = dart.override {
      version = dartVersion;
      sources = {
        "${dartVersion}-x86_64-linux" = fetchurl {
          url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
          sha256 = dartHash.x86_64-linux;
        };
        "${dartVersion}-aarch64-linux" = fetchurl {
          url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-linux-arm64-release.zip";
          sha256 = dartHash.aarch64-linux;
        };
      };
    };

    src = fetchurl {
      url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz";
      sha256 = hash;
    };
  }) { };
in
{
  stable = mkFlutter {
    version = "3.7.9";
    dartVersion = "2.19.6";
    hash = "sha256-UtJuYS7lzFPXLGoO8VR1DOeCVcSYudsGYF3lbjY4Bb4=";
    dartHash = {
      x86_64-linux = "sha256-D9/yXmrLo9YJQVWn40FjT43jR36Gwv2krUcjLBrfcE8=";
      aarch64-linux = "sha256-aRO3wLO3i8FB03LNRz2iF3Hlc3Kxq0XJd84VUMj/C5w=";
    };
    patches = getPatches ./patches/flutter3;
  };

  v2 = mkFlutter {
    version = "2.10.5";
    dartVersion = "2.16.2";
    hash = "sha256-DTZwxlMUYk8NS1SaWUJolXjD+JnRW73Ps5CdRHDGnt0=";
    usePreload = false;
    dartHash = {
      x86_64-linux = "sha256-egrYd7B4XhkBiHPIFE2zopxKtQ58GqlogAKA/UeiXnI=";
      aarch64-linux = "sha256-vmerjXkUAUnI8FjK+62qLqgETmA+BLPEZXFxwYpI+KY=";
    };
    patches = getPatches ./patches/flutter2;
  };
}
