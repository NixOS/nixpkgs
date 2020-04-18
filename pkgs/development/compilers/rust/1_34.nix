{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.34.2";
  rustcSha256 = "0mig0prkmlnpbba1cmi17vlsl88ikv5pi26zjy2kcr64l62lm6n6";

  llvm = llvm_8;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_33.packages.stable.rustc;
    cargo = buildPackages.rust_1_33.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_34;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


