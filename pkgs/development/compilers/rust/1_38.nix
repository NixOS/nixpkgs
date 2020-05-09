{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.38.0";
  rustcSha256 = "101dlpsfkq67p0hbwx4acqq6n90dj4bbprndizpgh1kigk566hk4";

  llvm = llvm_8;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_37.packages.stable.rustc;
    cargo = buildPackages.rust_1_37.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_38;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


