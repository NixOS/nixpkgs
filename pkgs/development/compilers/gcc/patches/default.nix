{
  lib,
  stdenv,
  langC,
  langAda,
  langObjC,
  langObjCpp,
  langD,
  langFortran,
  langGo,
  reproducibleBuild,
  profiledCompiler,
  langJit,
  staticCompiler,
  enableShared,
  enableLTO,
  version,
  fetchpatch,
  majorVersion,
  targetPlatform,
  hostPlatform,
  noSysDirs,
  buildPlatform,
  fetchurl,
  withoutTargetLibc,
  threadsCross,
}:

let
  atLeast15 = lib.versionAtLeast version "15";
  atLeast14 = lib.versionAtLeast version "14";
  atLeast13 = lib.versionAtLeast version "13";
  atLeast12 = lib.versionAtLeast version "12";
  atLeast11 = lib.versionAtLeast version "11";
  atLeast10 = lib.versionAtLeast version "10";
  is15 = majorVersion == "15";
  is14 = majorVersion == "14";
  is13 = majorVersion == "13";
  is12 = majorVersion == "12";
  is11 = majorVersion == "11";
  is10 = majorVersion == "10";
  is9 = majorVersion == "9";

  # We only apply these patches when building a native toolchain for
  # aarch64-darwin, as it breaks building a foreign one:
  # https://github.com/iains/gcc-12-branch/issues/18
  canApplyIainsDarwinPatches =
    stdenv.hostPlatform.isDarwin
    && stdenv.hostPlatform.isAarch64
    && (lib.systems.equals buildPlatform hostPlatform)
    && (lib.systems.equals hostPlatform targetPlatform);

  inherit (lib) optionals optional;
in

#
#  Patches below are organized into three general categories:
#  1. Patches relevant to gcc>=12 on every platform
#  2. Patches relevant to gcc>=12 on specific platforms
#  3. Patches relevant only to gcc<12
#

## 1. Patches relevant to gcc>=12 on every platform ####################################

[ ]
# Backport "c++: conversion to base of vbase in NSDMI"
# Fixes https://gcc.gnu.org/bugzilla/show_bug.cgi?id=80431
++ optional (!atLeast12) (fetchpatch {
  name = "gcc-bug80431-fix";
  url = "https://github.com/gcc-mirror/gcc/commit/de31f5445b12fd9ab9969dc536d821fe6f0edad0.patch";
  hash = "sha256-bnHKJP5jR8rNJjRTi58/N/qZ5fPkuFBk7WblJWQpKOs=";
})
# Pass the path to a C++ compiler directly in the Makefile.in
++ optional (!lib.systems.equals targetPlatform hostPlatform) ./libstdc++-target.patch
++ optionals (noSysDirs) (
  [
    # Do not try looking for binaries and libraries in /lib and /usr/lib
    (if atLeast12 then ./gcc-12-no-sys-dirs.patch else ./no-sys-dirs.patch)
  ]
  ++ (
    {
      "15" = [
        # Do not try looking for binaries and libraries in /lib and /usr/lib
        ./13/no-sys-dirs-riscv.patch
        # Mangle the nix store hash in __FILE__ to prevent unneeded runtime references
        ./13/mangle-NIX_STORE-in-__FILE__.patch
      ];
      "14" = [
        ./13/no-sys-dirs-riscv.patch
        ./13/mangle-NIX_STORE-in-__FILE__.patch
      ];
      "13" = [
        ./13/no-sys-dirs-riscv.patch
        ./13/mangle-NIX_STORE-in-__FILE__.patch
      ];
      "12" = [
        ./no-sys-dirs-riscv.patch
        ./12/mangle-NIX_STORE-in-__FILE__.patch
      ];
      "11" = [ ./no-sys-dirs-riscv.patch ];
      "10" = [ ./no-sys-dirs-riscv.patch ];
      "9" = [ ./no-sys-dirs-riscv-gcc9.patch ];
    }
    ."${majorVersion}" or [ ]
  )
)
# Pass CFLAGS on to gnat
++ optional (atLeast12 && langAda) ./gnat-cflags-11.patch
++ optional langFortran (
  # Fix interaction of gfortran and libtool
  # Fixes the output of -v
  # See also https://github.com/nixOS/nixpkgs/commit/cc6f814a8f0e9b70ede5b24192558664fa1f98a2
  if atLeast12 then ./gcc-12-gfortran-driving.patch else ./gfortran-driving.patch
)
# Do not pass a default include dir on PowerPC+Musl
# See https://github.com/NixOS/nixpkgs/pull/45340/commits/d6bb7d45162ac93e017cc9b665ae4836f6410710
++ [ ./ppc-musl.patch ]
# Patches for libphobos, the standard library of the D language
# - Forces libphobos to be built with -j1, as libtool misbehaves in parallel
# - Gets rid of -idirafter flags added by our gcc wrappers, as gdc does not understand them
# See https://github.com/NixOS/nixpkgs/pull/69144#issuecomment-535176453
++ optional langD ./libphobos.patch
# Moves the .cfi_starproc instruction to after the function label
# Needed to build llvm-18 and later
# See https://github.com/NixOS/nixpkgs/pull/354107/commits/2de1b4b14e17f42ba8b4bf43a29347c91511e008
++ optional (!atLeast14) ./cfi_startproc-reorder-label-09-1.diff
++ optional (atLeast14 && !canApplyIainsDarwinPatches) ./cfi_startproc-reorder-label-14-1.diff

## 2. Patches relevant to gcc>=12 on specific platforms ####################################

### Musl+Go+gcc12

# backport fixes to build gccgo with musl libc
++ optionals (stdenv.hostPlatform.isMusl && langGo && atLeast12) [
  # libgo: handle stat st_atim32 field and SYS_SECCOMP
  # syscall: gofmt
  # Add blank lines after //sys comments where needed, and then run gofmt
  # on the syscall package with the new formatter.
  # See https://go-review.googlesource.com/c/gofrontend/+/412074
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/cf79b1117bd177d3d4c6ed24b6fa243c3628ac2d.diff";
    hash = "sha256-mS5ZiYi5D8CpGXrWg3tXlbhp4o86ew1imCTwaHLfl+I=";
  })
  # libgo: permit loff_t and off_t to be macros
  # See https://go-review.googlesource.com/c/gofrontend/+/412075
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/7f195a2270910a6ed08bd76e3a16b0a6503f9faf.diff";
    hash = "sha256-Ze/cFM0dQofKH00PWPDoklXUlwWhwA1nyTuiDAZ6FKo=";
  })
  # libgo: handle stat st_atim32 field and SYS_SECCOMP
  # See https://go-review.googlesource.com/c/gofrontend/+/415294
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/762fd5e5547e464e25b4bee435db6df4eda0de90.diff";
    hash = "sha256-o28upwTcHAnHG2Iq0OewzwSBEhHs+XpBGdIfZdT81pk=";
  })
  # runtime: portable access to sigev_notify_thread_id
  # See https://sourceware.org/bugzilla/show_bug.cgi?id=27417
  # See https://go-review.googlesource.com/c/gofrontend/+/434755
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/e73d9fcafbd07bc3714fbaf8a82db71d50015c92.diff";
    hash = "sha256-1SjYCVHLEUihdON2TOC3Z2ufM+jf2vH0LvYtZL+c1Fo=";
  })
  # syscall, runtime: always call XSI strerror_r
  # See https://go-review.googlesource.com/c/gofrontend/+/454176
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/b6c6a3d64f2e4e9347733290aca3c75898c44b2e.diff";
    hash = "sha256-RycJ3YCHd3MXtYFjxP0zY2Wuw7/C4bWoBAQtTKJZPOQ=";
  })
  # libgo: check for makecontext in -lucontext
  # See https://go-review.googlesource.com/c/gofrontend/+/458396
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/2b1a604a9b28fbf4f382060bebd04adb83acc2f9.diff";
    hash = "sha256-WiBQG0Xbk75rHk+AMDvsbrm+dc7lDH0EONJXSdEeMGE=";
  })
  # x86: Fix -fsplit-stack feature detection via  TARGET_CAN_SPLIT_STACK
  # Fixes compiling for non-glibc target
  (fetchpatch {
    url = "https://github.com/gcc-mirror/gcc/commit/c86b726c048eddc1be320c0bf64a897658bee13d.diff";
    hash = "sha256-QSIlqDB6JRQhbj/c3ejlmbfWz9l9FurdSWxpwDebnlI=";
  })
]

## Darwin

# Fixes detection of Darwin on x86_64-darwin. Otherwise, GCC uses a deployment target of 10.5, which crashes ld64.
++ optional (
  is14 && stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
) ../patches/14/libgcc-darwin-detection.patch
++ optional (
  atLeast15 && stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
) ../patches/15/libgcc-darwin-detection.patch

# Fix detection of bootstrap compiler Ada support (cctools as) on Nix Darwin
++ optional (
  atLeast12 && stdenv.hostPlatform.isDarwin && langAda
) ./ada-cctools-as-detection-configure.patch

# Remove CoreServices on Darwin, as it is only needed for macOS SDK 14+
++ optional (
  atLeast14 && stdenv.hostPlatform.isDarwin && langAda
) ../patches/14/gcc-darwin-remove-coreservices.patch

# Use absolute path in GNAT dylib install names on Darwin
++ optionals (stdenv.hostPlatform.isDarwin && langAda) (
  {
    "15" = [ ../patches/14/gnat-darwin-dylib-install-name-14.patch ];
    "14" = [ ../patches/14/gnat-darwin-dylib-install-name-14.patch ];
    "13" = [ ./gnat-darwin-dylib-install-name-13.patch ];
    "12" = [ ./gnat-darwin-dylib-install-name.patch ];
  }
  .${majorVersion} or [ ]
)

# Here we apply patches by Iains (https://github.com/iains)
# GitHub's "compare" API produces unstable diffs, so we resort to reusing
# diffs from the Homebrew repo.
++ optionals canApplyIainsDarwinPatches (
  {
    "15" = [
      # Patches from https://github.com/iains/gcc-15-branch/compare/releases/gcc-15..gcc-15.1-darwin-rc1
      (fetchpatch {
        name = "gcc-15-darwin-aarch64-support.patch";
        url = "https://raw.githubusercontent.com/Homebrew/formula-patches/a25079204c1cb3d78ba9dd7dd22b8aecce7ce264/gcc/gcc-15.1.0.diff";
        sha256 = "sha256-MJxSGv6LEP1sIM8cDqbmfUV7byV0bYgADeIBY/Teyu8=";
      })
    ];
    "14" = [
      # Patches from https://github.com/iains/gcc-14-branch/compare/04696df09633baf97cdbbdd6e9929b9d472161d3..gcc-14.2-darwin-r2
      (fetchpatch {
        # There are no upstream release tags nor a static branch for 14.3.0 in https://github.com/iains/gcc-14-branch.
        # aa4cd614456de65ee3417acb83c6cff0640144e9 is the merge base of https://github.com/iains/gcc-14-branch/tree/gcc-14-3-darwin-pre-0 and https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-14.3.0
        # 3e1d48d240f4aa5223c701b5c231c66f66ab1126 is the newest commit of https://github.com/iains/gcc-14-branch/tree/gcc-14-3-darwin-pre-0
        name = "gcc-14-darwin-aarch64-support.patch";
        url = "https://github.com/iains/gcc-14-branch/compare/aa4cd614456de65ee3417acb83c6cff0640144e9..3e1d48d240f4aa5223c701b5c231c66f66ab1126.diff";
        hash = "sha256-BSTSYnkBJBEm++mGerVVyaCUC4dUyXq0N1tqbk25bO4=";
      })
    ];
    # Patches from https://github.com/iains/gcc-13-branch/compare/b71f1de6e9cf7181a288c0f39f9b1ef6580cf5c8..gcc-13-3-darwin
    "13" = [
      (fetchpatch {
        name = "gcc-13-darwin-aarch64-support.patch";
        url = "https://raw.githubusercontent.com/Homebrew/formula-patches/bda0faddfbfb392e7b9c9101056b2c5ab2500508/gcc/gcc-13.3.0.diff";
        sha256 = "sha256-RBTCBXIveGwuQGJLzMW/UexpUZdDgdXprp/G2NHkmQo=";
      })
      # Needed to build LLVM>18
      ./cfi_startproc-reorder-label-2.diff
    ];
    # Patches from https://github.com/iains/gcc-12-branch/compare/2bada4bc59bed4be34fab463bdb3c3ebfd2b41bb..gcc-12-4-darwin
    "12" = [
      (fetchurl {
        name = "gcc-12-darwin-aarch64-support.patch";
        url = "https://raw.githubusercontent.com/Homebrew/formula-patches/1ed9eaea059f1677d27382c62f21462b476b37fe/gcc/gcc-12.4.0.diff";
        sha256 = "sha256-wOjpT79lps4TKG5/E761odhLGCphBIkCbOPiQg/D1Fw=";
      })
      # Needed to build LLVM>18
      ./cfi_startproc-reorder-label-2.diff
    ];
    "11" = [
      (fetchpatch {
        # There are no upstream release tags in https://github.com/iains/gcc-11-branch.
        # 5cc4c42a0d4de08715c2eef8715ad5b2e92a23b6 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-11.5.0
        url = "https://github.com/iains/gcc-11-branch/compare/5cc4c42a0d4de08715c2eef8715ad5b2e92a23b6..gcc-11.5-darwin-r0.diff";
        hash = "sha256-7lH+GkgkrE6nOp9PMdIoqlQNWK31s6oW+lDt1LIkadE=";
      })
      # Needed to build LLVM>18
      ./cfi_startproc-reorder-label-2.diff
    ];
    "10" = [
      (fetchpatch {
        # There are no upstream release tags in https://github.com/iains/gcc-10-branch.
        # d04fe55 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-10.5.0
        url = "https://github.com/iains/gcc-10-branch/compare/d04fe5541c53cb16d1ca5c80da044b4c7633dbc6...gcc-10-5Dr0-pre-0.diff";
        hash = "sha256-kVUHZKtYqkWIcqxHG7yAOR2B60w4KWLoxzaiFD/FWYk=";
      })
      # Needed to build LLVM>18
      ./cfi_startproc-reorder-label-2.diff
    ];
  }
  .${majorVersion} or [ ]
)

# Work around newer AvailabilityInternal.h when building older versions of GCC.
++ optionals (stdenv.hostPlatform.isDarwin) (
  {
    "9" = [ ../patches/9/AvailabilityInternal.h-fixincludes.patch ];
  }
  .${majorVersion} or [ ]
)

## Windows

# Backported mcf thread model support from gcc13:
# https://github.com/gcc-mirror/gcc/commit/f036d759ecee538555fa8c6b11963e4033732463
++ optional (
  !atLeast13 && !withoutTargetLibc && targetPlatform.isMinGW && threadsCross.model == "mcf"
) (./. + "/${majorVersion}/Added-mcf-thread-model-support-from-mcfgthread.patch")

##############################################################################
##
##  3. Patches relevant only to gcc<12
##
##  Above this point are patches which might potentially be applied
##  to gcc version 12 or newer.  Below this point are patches which
##  will *only* be used for gcc versions older than gcc12.
##
##############################################################################

## gcc 11.0 and older ##############################################################################

# openjdk build fails without this on -march=opteron; is upstream in gcc12
++ optional is11 (fetchpatch {
  name = "darwin-aarch64-self-host-driver.patch";
  url = "https://github.com/gcc-mirror/gcc/commit/d243f4009d8071b734df16cd70f4c5d09a373769.patch";
  sha256 = "sha256-H97GZs2wwzfFGiFOgds/5KaweC+luCsWX3hRFf7+Sm4=";
})

## gcc 10.0 and older ##############################################################################

# Probably needed for gnat wrapper https://github.com/NixOS/nixpkgs/pull/62314
++ optional (langAda && (is9 || is10)) ./gnat-cflags.patch
++
  # Backport native aarch64-darwin compilation fix from gcc12
  # https://github.com/NixOS/nixpkgs/pull/167595
  optional
    (
      is10
      && buildPlatform.system == "aarch64-darwin"
      && (!lib.systems.equals targetPlatform buildPlatform)
    )
    (fetchpatch {
      name = "0008-darwin-aarch64-self-host-driver.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/834c8749ced550af3f17ebae4072fb7dfb90d271.diff";
      sha256 = "sha256-XtykrPd5h/tsnjY1wGjzSOJ+AyyNLsfnjuOZ5Ryq9vA=";
    })

# Fix undefined symbol errors when building older versions with clang
++ optional (
  !atLeast11 && stdenv.cc.isClang && stdenv.hostPlatform.isDarwin
) ./clang-genconditions.patch

## gcc 9.0 and older ##############################################################################

++ optional (majorVersion == "9") ./9/fix-struct-redefinition-on-glibc-2.36.patch
# Needed for NetBSD cross comp in older versions
# https://gcc.gnu.org/pipermail/gcc-patches/2020-January/thread.html#537548
# https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=98d56ea8900fdcff8f1987cf2bf499a5b7399857
++ optional (!atLeast10 && targetPlatform.isNetBSD) ./libstdc++-netbsd-ctypes.patch

# Make Darwin bootstrap respect whether the assembler supports `--gstabs`,
# which is not supported by the clang integrated assembler used by default on Darwin.
++ optional (is9 && hostPlatform.isDarwin) ./9/gcc9-darwin-as-gstabs.patch
