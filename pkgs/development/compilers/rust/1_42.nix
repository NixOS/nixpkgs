# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
# 3. Firefox and Thunderbird should still build on x86_64-linux.

{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_9
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.42.0";
  rustcSha256 = "0x9lxs82may6c0iln0b908cxyn1cv7h03n5cmbx3j1bas4qzks6j";

  llvm = llvm_9;

  enableRustcDev = true;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_41.packages.stable.rustc;
    cargo = buildPackages.rust_1_41.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_42;

  rustcPatches = [
    ./0001-Allow-getting-no_std-from-the-config-file.patch
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_9" ])


