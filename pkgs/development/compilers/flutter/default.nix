{ callPackage, fetchurl, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  wrapFlutter = flutter: callPackage (import ./wrapper.nix) { flutter = flutter; };
  mkFlutterFHS = flutter: callPackage (import ./fhs.nix) { flutter = flutter; };
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
in
{
  inherit mkFlutter wrapFlutter mkFlutterFHS flutterDrv;
  stable = flutterDrv {
    version = "3.3.3";
    dartVersion = "2.18.2";
    hash = "sha256-MTZeWQUp4/TcPzYIT6eqIKSPUPvn2Mp/thOQzNgpTXg=";
    dartHash = {
      x86_64-linux = "sha256-C3+YjecXLvSmJrLwi9H7TgD9Np0AArRWx3EdBrfQpTU";
      aarch64-linux = "sha256-zyIK1i5/9P2C+sjzdArhFwpVO4P+It+/X50l+n9gekI=";
    };
    patches = getPatches ./patches/flutter3;
  };

  v2 = flutterDrv {
    version = "2.10.5";
    dartVersion = "2.16.2";
    hash = "sha256-DTZwxlMUYk8NS1SaWUJolXjD+JnRW73Ps5CdRHDGnt0=";
    dartHash = {
      x86_64-linux = "sha256-egrYd7B4XhkBiHPIFE2zopxKtQ58GqlogAKA/UeiXnI=";
      aarch64-linux = "sha256-vmerjXkUAUnI8FjK+62qLqgETmA+BLPEZXFxwYpI+KY=";
    };
    patches = getPatches ./patches/flutter2;
  };
}
