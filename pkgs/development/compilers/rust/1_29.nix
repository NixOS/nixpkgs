{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_7
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.29.0";
  rustcSha256 = "1sb15znckj8pc8q3g7cq03pijnida6cg64yqmgiayxkzskzk9sx4";

  llvm = llvm_7;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.mrustc-full;
    cargo = buildPackages.mrustc-full;
  };

  selectRustPackage = pkgs: pkgs.rust_1_29;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_7" ])


