{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_7
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.32.0";
  rustcSha256 = "0ji2l9xv53y27xy72qagggvq47gayr5lcv2jwvmfirx029vlqnac";

  llvm = llvm_7;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_31.packages.stable.rustc;
    cargo = buildPackages.rust_1_31.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_32;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_7" ])


