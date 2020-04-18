{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.35.0";
  rustcSha256 = "0bbizy6b7002v1rdhrxrf5gijclbyizdhkglhp81ib3bf5x66kas";

  llvm = llvm_8;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_34.packages.stable.rustc;
    cargo = buildPackages.rust_1_34.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_35;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


