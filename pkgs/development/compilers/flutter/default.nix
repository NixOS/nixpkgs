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
          sha256 = dartHash;
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
  inherit mkFlutter;
  stable = flutterDrv {
    pname = "flutter";
    version = "3.3.3";
    dartVersion = "2.18.2";
    hash = "sha256-MTZeWQUp4/TcPzYIT6eqIKSPUPvn2Mp/thOQzNgpTXg=";
    dartHash = "sha256-C3+YjecXLvSmJrLwi9H7TgD9Np0AArRWx3EdBrfQpTU";
    patches = getPatches ./patches/flutter3;
  };

  v2 = flutterDrv {
    pname = "flutter";
    version = "2.10.5";
    dartVersion = "2.16.2";
    hash = "sha256-DTZwxlMUYk8NS1SaWUJolXjD+JnRW73Ps5CdRHDGnt0=";
    dartHash = "sha256-egrYd7B4XhkBiHPIFE2zopxKtQ58GqlogAKA/UeiXnI=";
    patches = getPatches ./patches/flutter2;
  };
}
