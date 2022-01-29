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
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild, pkgsBuildHost
, makeRustPlatform
, llvmPackages_11
, llvmPackages_13, llvm_13
, fetchpatch
} @ args:

import ./default.nix {
  rustcVersion = "1.56.1";
  rustcSha256 = "04cmqx7nn63hzz7z27b2b0dj2qx18rck9ifvip43s6dampx8v2f3";

  llvmSharedForBuild = pkgsBuildBuild.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvmPackages_13.libllvm.override { enableSharedLibraries = true; };

  llvmBootstrapForDarwin = llvmPackages_11;

  # For use at runtime
  llvmShared = llvm_13.override { enableSharedLibraries = true; };

  # Expose llvmPackages used for rustc from rustc via passthru for LTO in Firefox
  llvmPackagesForBuild = pkgsBuildBuild.llvmPackages_13;

  # Note: the version MUST be one version prior to the version we're
  # building
  bootstrapVersion = "1.55.0";

  # fetch hashes by running `print-hashes.sh ${bootstrapVersion}`
  bootstrapHashes = {
    i686-unknown-linux-gnu = "6e42b6c44d2eb4170f4144423fa3c33338d8d5c3ea00b03bbac200c877bc9e98";
    x86_64-unknown-linux-gnu = "2080253a2ec36ac8ed6e060d30802d888533124b8d16545cfd4af898b365eaac";
    x86_64-unknown-linux-musl = "f24f68587253c4bfbe59d3d10fe4897068d9130538de6b2d02097a25718030c2";
    arm-unknown-linux-gnueabihf = "483444153d35cda51c6aec2c24bc4c97fa4fd30b28df4b60bf9763bd6e06da3a";
    armv7-unknown-linux-gnueabihf = "8c72f0eb75b10db970fb546c3b41f5e97df294d5dbbf0b8fa96e17f2b281ee9c";
    aarch64-unknown-linux-gnu = "eebdb2e659ed14884a49f0457d44e5e8c9f89fca3414533752c6dbb96232c156";
    aarch64-unknown-linux-musl = "2ce36a7d34f1f2aa43b4cbc0b437d96eefb45743828bf9ae699ff581ae257f28";
    x86_64-apple-darwin = "2e345ac7724c192c9487a2c6bd4f6c52c884d791981510288830d27d9a0bf2f3";
    aarch64-apple-darwin = "70c71d30d0de76912fcd88d503a6cb4323cfe6250c1a255be7e0d4e644b3d40a";
    powerpc64le-unknown-linux-gnu = "12bf6447d338cbe2b55539b84e6369b17e7eefe938d1ba7e3dd69781c9cc9812";
    riscv64gc-unknown-linux-gnu = "effceb45346fef3b0b54b357336e6f374f788b803bb1bee4084f25eace8907f3";
  };

  selectRustPackage = pkgs: pkgs.rust_1_56;

  rustcPatches = [
    # Patch 0001 was skipped as it doesn't apply cleanly and affects Windows-only code.
    (fetchpatch {
      name = "0002-CVE-2022-21658.patch";
      url = "https://raw.githubusercontent.com/rust-lang/wg-security-response/240384a5fd494d4f8167c0ffa8ef566661003d8a/patches/CVE-2022-21658/0002-Fix-CVE-2022-21658-for-UNIX-like.patch";
      sha256 = "0gwjp7clh52mg2pps44awwpdq9zq2nci8q97jaljis7h16yx3ra7";
    })
    (fetchpatch {
      name = "0003-CVE-2022-21658.patch";
      url = "https://raw.githubusercontent.com/rust-lang/wg-security-response/240384a5fd494d4f8167c0ffa8ef566661003d8a/patches/CVE-2022-21658/0003-Fix-CVE-2022-21658-for-WASI.patch";
      sha256 = "01d77a15gikzkql4q6y43bx1cx8hy8n71v1qmlnzp7wg40v78xrp";
    })
    (fetchpatch {
      name = "0004-CVE-2022-21658.patch";
      url = "https://raw.githubusercontent.com/rust-lang/wg-security-response/240384a5fd494d4f8167c0ffa8ef566661003d8a/patches/CVE-2022-21658/0004-Update-std-fs-remove_dir_all-documentation.patch";
      sha256 = "08afz21m1k12245q1jg813cnwl8gc95ajbzqn6mwlppqhhi4wdq2";
    })
    # Patch 0005 was skipped as it doesn't apply cleanly and only affects platforms that aren't Linux.
  ];
}

(builtins.removeAttrs args [ "fetchpatch" "pkgsBuildHost" "llvmPackages_11" "llvmPackages_13" "llvm_13"])
