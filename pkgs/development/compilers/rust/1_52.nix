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
, llvmPackages_11, llvm_11
} @ args:

import ./default.nix {
  rustcVersion = "1.52.1";
  rustcSha256 = "sha256-Om8jom0Oj4erv78yxc19qgwLcdCYar78Vrml+/vQv5g=";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_11.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_11.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_11.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_11.override { enableSharedLibraries = true; };

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.51.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "de2e8ef724d89ba6f567f07ebacf5a244c7cdae30ee559f1913310eda38d9cd1";
    x86_64-unknown-linux-gnu = "9e125977aa13f012a68fdc6663629c685745091ae244f0587dd55ea4e3a3e42f";
    x86_64-unknown-linux-musl = "cb65c3a19ba0e09a94ccfd8551e648efaa1db52b0db19ae475d35a46f8750871";
    arm-unknown-linux-gnueabihf = "ab26464947ce80b4c361b08242dc215a5664f9f4ad23f66891ec27d55a0440b7";
    armv7-unknown-linux-gnueabihf = "5d381b7ee16c559efefedfac7ec4d392e838fddaf50049255844dcff2b2614dd";
    aarch64-unknown-linux-gnu = "fd31c78fffad52c03cac5a7c1ee5db3f34b2a77d7bc862707c0f71e209180a84";
    aarch64-unknown-linux-musl = "06cdaa1117dcdd392ede938b655b9bc45cf2a76bd42870ca223189e6eb29d435";
    x86_64-apple-darwin = "765212098a415996b767d1e372ce266caf94027402b269fec33291fffc085ca4";
    aarch64-apple-darwin = "95d0410bbd20b05f8b7d5adf70e8737873995bc86611a90e643d7081ca35147f";
    powerpc64le-unknown-linux-gnu = "7362f561104d7be4836507d3a53cd39444efcdf065813d559beb1f54ce9f7680";
  };

  selectRustPackage = pkgs: pkgs.rust_1_52;

  rustcPatches = [
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvm_11"])
