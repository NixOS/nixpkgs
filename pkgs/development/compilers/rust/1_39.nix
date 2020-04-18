{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.39.0";
  rustcSha256 = "0mwkc1bnil2cfyf6nglpvbn2y0zfbv44zfhsd5qg4c9rm6vgd8dl";

  llvm = llvm_8;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_38.packages.stable.rustc;
    cargo = buildPackages.rust_1_38.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_39;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


