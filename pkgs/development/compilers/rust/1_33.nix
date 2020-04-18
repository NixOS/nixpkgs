{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_7
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.33.0";
  rustcSha256 = "152x91mg7bz4ygligwjb05fgm1blwy2i70s2j03zc9jiwvbsh0as";

  llvm = llvm_7;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_32.packages.stable.rustc;
    cargo = buildPackages.rust_1_32.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_33;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_7" ])


