{ callPackage, fetchurl, dart }:
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
  };
  flutter2Patches = getPatches ./patches/flutter2;
  flutter3Patches = getPatches ./patches/flutter3;
in
{
  inherit mkFlutter wrapFlutter flutterDrv flutter3Patches flutter2Patches;
  stable = flutterDrv {
    version = "3.7.11";
    dartVersion = "2.19.6";
    hash = "sha256-/vtjoPB4Hn8RtP09uMdUYtDS7lzQvskdrNszEYlpOBc=";
    dartHash = {
      x86_64-linux = "sha256-D9/yXmrLo9YJQVWn40FjT43jR36Gwv2krUcjLBrfcE8=";
      aarch64-linux = "sha256-aRO3wLO3i8FB03LNRz2iF3Hlc3Kxq0XJd84VUMj/C5w=";
    };
    patches = flutter3Patches;
  };

  v2 = flutterDrv {
    version = "2.10.5";
    dartVersion = "2.16.2";
    hash = "sha256-DTZwxlMUYk8NS1SaWUJolXjD+JnRW73Ps5CdRHDGnt0=";
    dartHash = {
      x86_64-linux = "sha256-egrYd7B4XhkBiHPIFE2zopxKtQ58GqlogAKA/UeiXnI=";
      aarch64-linux = "sha256-vmerjXkUAUnI8FjK+62qLqgETmA+BLPEZXFxwYpI+KY=";
    };
    patches = flutter2Patches;
  };
}
