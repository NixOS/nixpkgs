{ stdenv, lib, callPackage, fetchurl, fetchzip, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  flutterDrv = { version, pname, dartVersion, flutterHash, dartHash, patches }: mkFlutter {
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
        "${dartVersion}-aarch64-darwin" = fetchurl {
          url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${dartVersion}/sdk/dartsdk-macos-arm64-release.zip";
          sha256 = dartHash.aarch64-darwin;
        };
      };
    };
    src = rec {
      x86_64-linux = fetchurl {
        url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz";
        sha256 = flutterHash.linux;
      };
      aarch64-linux = x86_64-linux;
      aarch64-darwin = fetchzip {
        url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64_"}${version}-stable.zip";
        sha256 = flutterHash.aarch64-darwin;
      };
    }.${stdenv.hostPlatform.system};
  };
in
{
  inherit mkFlutter;
  stable = flutterDrv {
    pname = "flutter";
    version = "3.3.8";
    dartVersion = "2.18.4";
    flutterHash = {
      linux = "sha256-QH+10F6a0XYEvBetiAi45Sfy7WTdVZ1i8VOO4JuSI24=";
      aarch64-darwin = "sha256-Lf2NoSH36pphLSTOGEwmm30SLcA5Kare+q7WBA4rRkY=";
    };
    dartHash = {
      x86_64-linux = "sha256-lFw+KaxzhuAMnu6ypczINqywzpiD+8Kd+C/UHJDrO9Y=";
      aarch64-linux = "sha256-snlFTY4oJ4ALGLc210USbI2Z///cx1IVYUWm7Vo5z2I=";
      aarch64-darwin = "sha256-KmtJ65KFvYHZsXsnPbMDsnTy3pXnQXGiAx9CwYq8nck=";
    };
    patches = [
      ./patches/flutter3/disable-auto-update.patch
      ./patches/flutter3/git-dir.patch
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux ./patches/flutter3/move-cache-linux.patch
    ++ lib.optional stdenv.hostPlatform.isDarwin ./patches/flutter3/move-cache-darwin.patch;
  };

  v2 = flutterDrv {
    pname = "flutter";
    version = "2.10.5";
    dartVersion = "2.16.2";
    flutterHash = {
      linux = "sha256-DTZwxlMUYk8NS1SaWUJolXjD+JnRW73Ps5CdRHDGnt0=";
    };
    dartHash = {
      x86_64-linux = "sha256-egrYd7B4XhkBiHPIFE2zopxKtQ58GqlogAKA/UeiXnI=";
      aarch64-linux = "sha256-vmerjXkUAUnI8FjK+62qLqgETmA+BLPEZXFxwYpI+KY=";
    };
    patches = getPatches ./patches/flutter2;
  };
}
