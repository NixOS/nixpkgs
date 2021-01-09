# New rust versions should first go to staging.
# Things to check after updating:
# 1. Rustc should produce rust binaries on x86_64-linux, aarch64-linux and x86_64-darwin:
#    i.e. nix-shell -p fd or @GrahamcOfBorg build fd on github
#    This testing can be also done by other volunteers as part of the pull
#    request review, in case platforms cannot be covered.
# 2. The LLVM version used for building should match with rust upstream.
#    Check the version number in the src/llvm-project git submodule in:
#    https://github.com/rust-lang/rust/blob/<version-tag>/.gitmodules
# 3. Firefox and Thunderbird should still build on x86_64-linux.

{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, llvmPackages_5, llvm_11
} @ args:

import ./default.nix {
  rustcVersion = "1.48.0";
  rustcSha256 = "0fz4gbb5hp5qalrl9lcl8yw4kk7ai7wx511jb28nypbxninkwxhf";

  llvmSharedForBuild = pkgsBuildBuild.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvm_11.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvm_11.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_5;

  # For use at runtime
  llvmShared = llvm_11.override { enableSharedLibraries = true; };

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.47.0";

  # fetch hashes by running `print-hashes.sh 1.45.2`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "84bf092130ea5216fc701871e633563fc1c01b6528f60cb0767e96cd8eec30bf";
    x86_64-unknown-linux-gnu = "d0e11e1756a072e8e246b05d54593402813d047d12e44df281fbabda91035d96";
    arm-unknown-linux-gnueabihf = "82e12affb47596b68d0ca64045f4eb698c10ff15406afca604e12cdd07e17b26";
    armv7-unknown-linux-gnueabihf = "19d0fe3892a8e98f99c5aa84f4d6f260853147650cb71f2bae985c91de6c29af";
    aarch64-unknown-linux-gnu = "753c905e89a714ab9bce6fe1397b721f29c0760c32f09d2f328af3d39919c8e6";
    x86_64-apple-darwin = "84e5be6c5c78734deba911dcf80316be1e4c7da2c59413124d039ad96620612f";
    powerpc64le-unknown-linux-gnu = "5760c3b1897ea70791320c2565f3eef700a3d54059027b84bbe6b8d6157f81c8";
  };

  selectRustPackage = pkgs: pkgs.rust_1_48;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_5" "llvm_11"])
