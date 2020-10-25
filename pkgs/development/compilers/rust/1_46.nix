# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules
# 3. Firefox and Thunderbird should still build on x86_64-linux.

{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages
, pkgsBuildTarget, pkgsBuildBuild
, makeRustPlatform
} @ args:

import ./default.nix {
  rustcVersion = "1.46.0";
  rustcSha256 = "0a17jby2pd050s24cy4dfc0gzvgcl585v3vvyfilniyvjrqknsid";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.45.2";

  # fetch hashes by running `print-hashes.sh 1.45.2`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "5b2050dde23152750de89f7e59acaab6bf088d0beb5854c69c9a545fd254b936";
    x86_64-unknown-linux-gnu = "860feed955726a4d96ffe40758a110053326b9ae11c9e1ee059e9c6222f25643";
    arm-unknown-linux-gnueabihf = "ddb5f59bbdef84e0b7c83049461e003ed031dd881a4622365c3d475102535c60";
    armv7-unknown-linux-gnueabihf = "7a556581f87602705f9c89b04cce621cfbba9050b6fbe478166e91d164567531";
    aarch64-unknown-linux-gnu = "151fad66442d28a4e4786753d1afb559c4a3d359081c64769273a31c2f0f4d30";
    x86_64-apple-darwin = "6e8067624ede10aa23081d62e0086c6f42f7228cc0d00fb5ff24d4dac65249d6";
  };

  selectRustPackage = pkgs: pkgs.rust_1_46;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" ])
