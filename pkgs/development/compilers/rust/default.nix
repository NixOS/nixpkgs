{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm, fetchurl
, CoreFoundation, Security
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
  version = "1.32.0";
  cargoVersion = "1.32.0";
  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "0ji2l9xv53y27xy72qagggvq47gayr5lcv2jwvmfirx029vlqnac";
  };
in rec {
  rustc = callPackage ./rustc.nix {
    inherit stdenv llvm targets targetPatches targetToolchains rustPlatform version src;

    patches = [
      ./patches/net-tcp-disable-tests.patch

      # Re-evaluate if this we need to disable this one
      #./patches/stdsimd-disable-doctest.patch
    ];

    withBundledLLVM = false;

    configureFlags = [ "--release-channel=stable" ];

    # 1. Upstream is not running tests on aarch64:
    # see https://github.com/rust-lang/rust/issues/49807#issuecomment-380860567
    # So we do the same.
    # 2. Tests run out of memory for i686
    #doCheck = !stdenv.isAarch64 && !stdenv.isi686;

    # Disabled for now; see https://github.com/NixOS/nixpkgs/pull/42348#issuecomment-402115598.
    doCheck = false;
  };

  cargo = callPackage ./cargo.nix rec {
    version = cargoVersion;
    inherit src stdenv CoreFoundation Security;
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}
