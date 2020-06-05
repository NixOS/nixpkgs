# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
# 3. Firefox and Thunderbird should still build on x86_64-linux.

{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.44.1";
  rustcSha256 = "0ww4z2v3gxgn3zddqzwqya1gln04p91ykbrflnpdbmcd575n8bky";

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.43.1";

  # fetch hashes by running `print-hashes.sh 1.44.1`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "0626fa8a6a2387021413d740543f7496656d81115e2284e4ef73217128398990";
    x86_64-unknown-linux-gnu = "25cd71b95bba0daef56bad8c943a87368c4185b90983f4412f46e3e2418c0505";
    arm-unknown-linux-gnueabihf = "16b9c4861565a195323d144fd0f54c0ae794ee3d2a867682f8aedbdacaad5a6c";
    armv7-unknown-linux-gnueabihf = "0c32a5958a358a031e6ca52074cfd45256688dc334db315199f5dbbf7562e5b1";
    aarch64-unknown-linux-gnu = "fbb612387a64c9da2869725afffc1f66a72d6e7ba6667ba717cd52c33080b7fb";
    x86_64-apple-darwin = "e1c3e1426a9e615079159d6b619319235e3ca7b395e7603330375bfffcbb7003";
  };

  selectRustPackage = pkgs: pkgs.rust_1_44;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" ])
