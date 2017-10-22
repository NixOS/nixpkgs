{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.20.0";
in
rec {
  rustc = callPackage ./rustc.nix {
    inherit llvm targets targetPatches targetToolchains rustPlatform version;

    forceBundledLLVM = true;

    configureFlags = [ "--release-channel=stable" ];

    src = fetchurl {
      url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
      sha256 = "0542y4rnzlsrricai130mqyxl8r6rd991frb4qsnwb27yigqg91a";
    };

    patches = [
      ./patches/0001-Disable-fragile-tests-libstd-net-tcp-on-Darwin-Linux.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.22.0";
    srcSha = "0x9pm73hkkd1hq4qrmz8iv91djgpdsxzwll7jari0h77vpwajmw4";
    cargoSha256 = "0xd0rb8gcqy6xngsx9l30jg3fqrcwccgv904ksqs9c4d44hga0gd";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
