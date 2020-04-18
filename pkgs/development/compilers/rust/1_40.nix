{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.40.0";
  rustcSha256 = "1ba9llwhqm49w7sz3z0gqscj039m53ky9wxzhaj11z6yg1ah15yx";

  llvm = llvm_8;

  enableRustcDev = true;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_39.packages.stable.rustc;
    cargo = buildPackages.rust_1_39.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_40;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


