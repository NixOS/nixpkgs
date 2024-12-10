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
  atLeast14 = lib.versionAtLeast version "14";
  atLeast13 = lib.versionAtLeast version "13";
  atLeast12 = lib.versionAtLeast version "12";
  atLeast11 = lib.versionAtLeast version "11";
  atLeast10 = lib.versionAtLeast version "10";
  atLeast9 = lib.versionAtLeast version "9";
  atLeast8 = lib.versionAtLeast version "8";
  is14 = majorVersion == "14";
  is13 = majorVersion == "13";
  is12 = majorVersion == "12";
  is11 = majorVersion == "11";
  is10 = majorVersion == "10";
  is9 = majorVersion == "9";
  is8 = majorVersion == "8";
  is7 = majorVersion == "7";
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
++ optional (!atLeast12) ./fix-bug-80431.patch
++ optional (targetPlatform != hostPlatform) ./libstdc++-target.patch
++ optionals (noSysDirs) (
  [ (if atLeast12 then ./gcc-12-no-sys-dirs.patch else ./no-sys-dirs.patch) ]
  ++ (
    {
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
++ optional (atLeast12 && langAda) ./gnat-cflags-11.patch
++ optional langFortran (
  if atLeast12 then ./gcc-12-gfortran-driving.patch else ./gfortran-driving.patch
)
++ [ ./ppc-musl.patch ]
++ optional (atLeast9 && langD) ./libphobos.patch

## 2. Patches relevant to gcc>=12 on specific platforms ####################################

### Musl+Go+gcc12

# backport fixes to build gccgo with musl libc
++ optionals (stdenv.hostPlatform.isMusl && langGo && atLeast12) [
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/cf79b1117bd177d3d4c6ed24b6fa243c3628ac2d.diff";
    hash = "sha256-mS5ZiYi5D8CpGXrWg3tXlbhp4o86ew1imCTwaHLfl+I=";
  })
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/7f195a2270910a6ed08bd76e3a16b0a6503f9faf.diff";
    hash = "sha256-Ze/cFM0dQofKH00PWPDoklXUlwWhwA1nyTuiDAZ6FKo=";
  })
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/762fd5e5547e464e25b4bee435db6df4eda0de90.diff";
    hash = "sha256-o28upwTcHAnHG2Iq0OewzwSBEhHs+XpBGdIfZdT81pk=";
  })
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/e73d9fcafbd07bc3714fbaf8a82db71d50015c92.diff";
    hash = "sha256-1SjYCVHLEUihdON2TOC3Z2ufM+jf2vH0LvYtZL+c1Fo=";
  })
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/b6c6a3d64f2e4e9347733290aca3c75898c44b2e.diff";
    hash = "sha256-RycJ3YCHd3MXtYFjxP0zY2Wuw7/C4bWoBAQtTKJZPOQ=";
  })
  (fetchpatch {
    excludes = [ "gcc/go/gofrontend/MERGE" ];
    url = "https://github.com/gcc-mirror/gcc/commit/2b1a604a9b28fbf4f382060bebd04adb83acc2f9.diff";
    hash = "sha256-WiBQG0Xbk75rHk+AMDvsbrm+dc7lDH0EONJXSdEeMGE=";
  })
  (fetchpatch {
    url = "https://github.com/gcc-mirror/gcc/commit/c86b726c048eddc1be320c0bf64a897658bee13d.diff";
    hash = "sha256-QSIlqDB6JRQhbj/c3ejlmbfWz9l9FurdSWxpwDebnlI=";
  })
]

## Darwin

# Fixes detection of Darwin on x86_64-darwin. Otherwise, GCC uses a deployment target of 10.5, which crashes ld64.
++ optional (
  atLeast14 && stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
) ../patches/14/libgcc-darwin-detection.patch

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
    "14" = [ ../patches/14/gnat-darwin-dylib-install-name-14.patch ];
    "13" = [ ./gnat-darwin-dylib-install-name-13.patch ];
    "12" = [ ./gnat-darwin-dylib-install-name.patch ];
  }
  .${majorVersion} or [ ]
)

# We only apply this patch when building a native toolchain for aarch64-darwin, as it breaks building
# a foreign one: https://github.com/iains/gcc-12-branch/issues/18
++
  optionals
    (
      stdenv.hostPlatform.isDarwin
      && stdenv.hostPlatform.isAarch64
      && buildPlatform == hostPlatform
      && hostPlatform == targetPlatform
    )
    (
      {
        "14" = [
          (fetchpatch {
            # There are no upstream release tags in https://github.com/iains/gcc-14-branch.
            # 04696df09633baf97cdbbdd6e9929b9d472161d3 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-14.2.0
            name = "gcc-14-darwin-aarch64-support.patch";
            url = "https://github.com/iains/gcc-14-branch/compare/04696df09633baf97cdbbdd6e9929b9d472161d3..gcc-14.2-darwin-r0.diff";
            hash = "sha256-GEUz7KdGzd2WJ0gjX3Uddq2y9bWKdZpT3E9uZ09qLs4=";
          })
        ];
        "13" = [
          (fetchpatch {
            name = "gcc-13-darwin-aarch64-support.patch";
            url = "https://raw.githubusercontent.com/Homebrew/formula-patches/bda0faddfbfb392e7b9c9101056b2c5ab2500508/gcc/gcc-13.3.0.diff";
            sha256 = "sha256-RBTCBXIveGwuQGJLzMW/UexpUZdDgdXprp/G2NHkmQo=";
          })
        ];
        "12" = [
          (fetchurl {
            name = "gcc-12-darwin-aarch64-support.patch";
            url = "https://raw.githubusercontent.com/Homebrew/formula-patches/1ed9eaea059f1677d27382c62f21462b476b37fe/gcc/gcc-12.4.0.diff";
            sha256 = "sha256-wOjpT79lps4TKG5/E761odhLGCphBIkCbOPiQg/D1Fw=";
          })
        ];
        "11" = [
          (fetchpatch {
            # There are no upstream release tags in https://github.com/iains/gcc-11-branch.
            # 5cc4c42a0d4de08715c2eef8715ad5b2e92a23b6 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-11.5.0
            url = "https://github.com/iains/gcc-11-branch/compare/5cc4c42a0d4de08715c2eef8715ad5b2e92a23b6..gcc-11.5-darwin-r0.diff";
            hash = "sha256-7lH+GkgkrE6nOp9PMdIoqlQNWK31s6oW+lDt1LIkadE=";
          })
        ];
        "10" = [
          (fetchpatch {
            # There are no upstream release tags in https://github.com/iains/gcc-10-branch.
            # d04fe55 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-10.5.0
            url = "https://github.com/iains/gcc-10-branch/compare/d04fe5541c53cb16d1ca5c80da044b4c7633dbc6...gcc-10-5Dr0-pre-0.diff";
            hash = "sha256-kVUHZKtYqkWIcqxHG7yAOR2B60w4KWLoxzaiFD/FWYk=";
          })
        ];
      }
      .${majorVersion} or [ ]
    )

# Work around newer AvailabilityInternal.h when building older versions of GCC.
++ optionals (stdenv.hostPlatform.isDarwin) (
  {
    "9" = [ ../patches/9/AvailabilityInternal.h-fixincludes.patch ];
    "8" = [ ../patches/8/AvailabilityInternal.h-fixincludes.patch ];
    "7" = [ ../patches/7/AvailabilityInternal.h-fixincludes.patch ];
  }
  .${majorVersion} or [ ]
)

## Windows

# Obtain latest patch with ../update-mcfgthread-patches.sh
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
++ optionals (is11) [ ./11/gcc-issue-103910.patch ]

## gcc 10.0 and older ##############################################################################

++ optional (langAda && (is9 || is10)) ./gnat-cflags.patch
++
  optional (is10 && buildPlatform.system == "aarch64-darwin" && targetPlatform != buildPlatform)
    (fetchpatch {
      url = "https://raw.githubusercontent.com/richard-vd/musl-cross-make/5e9e87f06fc3220e102c29d3413fbbffa456fcd6/patches/gcc-${version}/0008-darwin-aarch64-self-host-driver.patch";
      sha256 = "sha256-XtykrPd5h/tsnjY1wGjzSOJ+AyyNLsfnjuOZ5Ryq9vA=";
    })

# Fix undefined symbol errors when building older versions with clang
++ optional (
  !atLeast11 && stdenv.cc.isClang && stdenv.hostPlatform.isDarwin
) ./clang-genconditions.patch

## gcc 9.0 and older ##############################################################################

++ optional (majorVersion == "9") ./9/fix-struct-redefinition-on-glibc-2.36.patch
++ optional (!atLeast10 && targetPlatform.isNetBSD) ./libstdc++-netbsd-ctypes.patch

# Make Darwin bootstrap respect whether the assembler supports `--gstabs`,
# which is not supported by the clang integrated assembler used by default on Darwin.
++ optional (is9 && hostPlatform.isDarwin) ./9/gcc9-darwin-as-gstabs.patch

## gcc 8.0 and older ##############################################################################

++ optional (!atLeast9) ./libsanitizer-no-cyclades-9.patch
++ optional (is7 || is8) ./9/fix-struct-redefinition-on-glibc-2.36.patch

# Make Darwin bootstrap respect whether the assembler supports `--gstabs`,
# which is not supported by the clang integrated assembler used by default on Darwin.
++ optional (is8 && hostPlatform.isDarwin) ./8/gcc8-darwin-as-gstabs.patch

# Make avr-gcc8 build on aarch64-darwin
# avr-gcc8 is maintained for the `qmk` package
# https://github.com/osx-cross/homebrew-avr/blob/main/Formula/avr-gcc%408.rb#L69
++ optional (
  is8 && targetPlatform.isAvr && hostPlatform.isDarwin && hostPlatform.isAarch64
) ./8/avr-gcc-8-darwin.patch

## gcc 7.0 and older ##############################################################################

++ optional (is7 && hostPlatform != buildPlatform) (fetchpatch {
  # XXX: Refine when this should be applied
  url = "https://git.busybox.net/buildroot/plain/package/gcc/7.1.0/0900-remove-selftests.patch?id=11271540bfe6adafbc133caf6b5b902a816f5f02";
  sha256 = "0mrvxsdwip2p3l17dscpc1x8vhdsciqw1z5q9i6p5g9yg1cqnmgs";
})
++ optionals (is7) [
  # https://gcc.gnu.org/ml/gcc-patches/2018-02/msg00633.html
  (./. + "/${majorVersion}/riscv-pthread-reentrant.patch")
  # https://gcc.gnu.org/ml/gcc-patches/2018-03/msg00297.html
  (./. + "/${majorVersion}/riscv-no-relax.patch")
  # Fix for asan w/glibc-2.34. Although there's no upstream backport to v7,
  # the patch from gcc 8 seems to work perfectly fine.
  (./. + "/${majorVersion}/gcc8-asan-glibc-2.34.patch")
  (./. + "/${majorVersion}/0001-Fix-build-for-glibc-2.31.patch")
]
++ optional (is7 && targetPlatform.libc == "musl" && targetPlatform.isx86_32) (fetchpatch {
  url = "https://git.alpinelinux.org/aports/plain/main/gcc/gcc-6.1-musl-libssp.patch?id=5e4b96e23871ee28ef593b439f8c07ca7c7eb5bb";
  sha256 = "1jf1ciz4gr49lwyh8knfhw6l5gvfkwzjy90m7qiwkcbsf4a3fqn2";
})
++ optional (
  (is7 || is8) && !atLeast9 && targetPlatform.libc == "musl"
) ./libgomp-dont-force-initial-exec.patch
