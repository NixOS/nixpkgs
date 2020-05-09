{ stdenv, lib, fetchpatch
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.41.1";
  rustcSha256 = "0jypz2mrzac41sj0zh07yd1z36g2s2rvgsb8g624sk4l14n84ijm";  # FIXME

  llvm = llvm_8;

  enableRustcDev = true;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_40.packages.stable.rustc;
    cargo = buildPackages.rust_1_40.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_41;

  rustcPatches = [
    # Allow getting no_std from the config file. See:
    # * https://github.com/NixOS/nixpkgs/commit/0b0e6918331b1e99d2b148e296a9bd0cd0dd5479
    # * https://github.com/rust-lang/rust/pull/69381
    (fetchpatch {
      url = "https://github.com/QuiltOS/rust/commit/f1803452b9e95bfdbc3b8763138b9f92c7d12b46.diff";
      sha256 = "1mzxaj46bq7ll617wg0mqnbnwr1da3hd4pbap8bjwhs3kfqnr7kk";
    })
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


