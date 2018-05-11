{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.26.1";
  cargoVersion = "1.26.1";
  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "1w0da0cysvzxqyn0ap0aprzlm006185yk5lq3v0b4hzcv0drd9vh";
  };
in rec {
  rustc = callPackage ./rustc.nix {
    inherit stdenv llvm targets targetPatches targetToolchains rustPlatform version src;

    patches = [];

    forceBundledLLVM = true;

    configureFlags = [ "--release-channel=stable" ];

    # 1. Upstream is not running tests on aarch64:
    # see https://github.com/rust-lang/rust/issues/49807#issuecomment-380860567
    # So we do the same.
    # 2. Tests run out of memory for i686
    doCheck = !stdenv.isAarch64 && !stdenv.isi686;
  };

  cargo = callPackage ./cargo.nix rec {
    version = cargoVersion;
    inherit src;
    inherit stdenv;
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
