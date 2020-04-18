{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_5
, llvm_8
, pkgsBuildTarget, pkgsBuildBuild
} @ args:

import ./default.nix {
  rustcVersion = "1.37.0";
  rustcSha256 = "1hrqprybhkhs6d9b5pjskfnc5z9v2l2gync7nb39qjb5s0h703hj";

  llvm = llvm_8;

  # rustc-dev didn't exist yet
  enableRustcDev = false;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapRustPackages = {
    rustc = buildPackages.rust_1_36.packages.stable.rustc;
    cargo = buildPackages.rust_1_36.packages.stable.cargo;
  };

  selectRustPackage = pkgs: pkgs.rust_1_37;

  # This specific version of Rust requires compiler-rt (for profiling).
  # See also:
  # * https://github.com/NixOS/nixpkgs/commit/b7a828031238b0962cd91131eba50844ef401b93
  # * https://github.com/NixOS/nixpkgs/commit/adb15c3a63fd96edcf7585394b8ccbeb1ceee336
  rustcPreConfigure = ''
    mkdir src/llvm-project/compiler-rt
    tar xf ${llvmPackages_5.compiler-rt.src} -C src/llvm-project/compiler-rt --strip-components=1
  '';

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "llvm_8" ])


