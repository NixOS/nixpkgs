{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_7
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.30.1";
  rustcSha256 = "0aavdc1lqv0cjzbqwl5n59yd0bqdlhn0zas61ljf38yrvc18k8rn";

  llvm = llvm_7;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.mrustc-bootstrap;
    cargo = buildPackages.mrustc-bootstrap;
  };

  selectRustPackage = pkgs: pkgs.rust_1_30;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_7" ])

