{ callPackage, fetchurl, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  flutterDrv = { version, pname, dartVersion, hash, dartHash, patches }: mkFlutter {
    inherit version pname patches;
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
  inherit mkFlutter flutterDrv flutter2Patches flutter3Patches;
  stable = flutterDrv {
    pname = "flutter";
    version = "3.7.3";
    dartVersion = "2.19.2";
    hash = "sha256-ez0pAM4ONn1z2FWR1dQ6EflKIjJ43TIgd2sDqD4jSGU=";
    dartHash = {
      x86_64-linux = "sha256-Mm9gharzpnM/PPLvrOGFE6+9B8cOQGjE2pxogBYd2ys=";
      aarch64-linux = "sha256-TG9ROb3nn1V6+SeQ0hnmTxouBDpleEjlYY77y4L5t34=";
    };
    patches = flutter3Patches;
  };

  v2 = flutterDrv {
    pname = "flutter";
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
