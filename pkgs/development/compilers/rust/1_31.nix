{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_7
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.31.1";
  rustcSha256 = "01pg2619bwjnhjbphryrbkwaz0lw8cfffm4xlz35znzipb04vmcs";

  llvm = llvm_7;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_30.packages.stable.rustc;
    cargo = buildPackages.rust_1_30.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_31;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_7" ])


