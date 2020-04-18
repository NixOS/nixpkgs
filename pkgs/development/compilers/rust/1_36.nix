{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.36.0";
  rustcSha256 = "06xv2p6zq03lidr0yaf029ii8wnjjqa894nkmrm6s0rx47by9i04";

  llvm = llvm_8;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_35.packages.stable.rustc;
    cargo = buildPackages.rust_1_35.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_36;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


