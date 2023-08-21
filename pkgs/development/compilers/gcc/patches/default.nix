{ lib, stdenv
, langC
, langAda
, langObjC
, langObjCpp
, langD
, langFortran
, langGo
, reproducibleBuild
, profiledCompiler
, langJit
, staticCompiler
, enableShared
, enableLTO
, version
, fetchpatch
, majorVersion
, targetPlatform
, hostPlatform
, noSysDirs
, buildPlatform
, fetchurl
, withoutTargetLibc
, threadsCross
}:

let
  atLeast13 = lib.versionAtLeast version "13";
  atLeast12 = lib.versionAtLeast version "12";
  atLeast11 = lib.versionAtLeast version "11";
  atLeast10 = lib.versionAtLeast version "10";
  atLeast9  = lib.versionAtLeast version  "9";
  atLeast8  = lib.versionAtLeast version  "8";
  atLeast7  = lib.versionAtLeast version  "7";
  atLeast6  = lib.versionAtLeast version  "6";
  atLeast49 = lib.versionAtLeast version  "4.9";
  is13 = majorVersion == "13";
  is12 = majorVersion == "12";
  is11 = majorVersion == "11";
  is10 = majorVersion == "10";
  is9  = majorVersion == "9";
  is8  = majorVersion == "8";
  is7  = majorVersion == "7";
  is6  = majorVersion == "6";
  is49 = majorVersion == "4" && lib.versions.minor version == "9";
  is48 = majorVersion == "4" && lib.versions.minor version == "8";
  inherit (lib) optionals optional;
in

optionals (is49 || is6) [
  ./9/fix-struct-redefinition-on-glibc-2.36.patch
] ++ optionals (is49 || (is6 && !stdenv.targetPlatform.isRedox)) [
  ./use-source-date-epoch.patch
] ++ optionals (is6 && !stdenv.targetPlatform.isRedox) [
  ./6/0001-Fix-build-for-glibc-2.31.patch
] ++ optionals (!atLeast6) [
  ./parallel-bconfig.patch
] ++ optionals (is49) [
  (./. + "/${lib.versions.major version}.${lib.versions.minor version}/parallel-strsignal.patch")
  (./. + "/${lib.versions.major version}.${lib.versions.minor version}/libsanitizer.patch")
  (fetchpatch {
    name = "avoid-ustat-glibc-2.28.patch";
    url = "https://gitweb.gentoo.org/proj/gcc-patches.git/plain/4.9.4/gentoo/100_all_avoid-ustat-glibc-2.28.patch?id=55fcb515620a8f7d3bb77eba938aa0fcf0d67c96";
    sha256 = "0b32sb4psv5lq0ij9fwhi1b4pjbwdjnv24nqprsk14dsc6xmi1g0";
  })
] ++ optionals (is7) [
  # https://gcc.gnu.org/ml/gcc-patches/2018-02/msg00633.html
  (./. + "/${majorVersion}/riscv-pthread-reentrant.patch")
  # https://gcc.gnu.org/ml/gcc-patches/2018-03/msg00297.html
  (./. + "/${majorVersion}/riscv-no-relax.patch")
  # Fix for asan w/glibc-2.34. Although there's no upstream backport to v7,
  # the patch from gcc 8 seems to work perfectly fine.
  (./. + "/${majorVersion}/gcc8-asan-glibc-2.34.patch")
  (./. + "/${majorVersion}/0001-Fix-build-for-glibc-2.31.patch")
] ++ optional (majorVersion == "9") ./9/fix-struct-redefinition-on-glibc-2.36.patch
++ optional (atLeast6 && !atLeast12) ./fix-bug-80431.patch
++ optional (is7 || is8) ./9/fix-struct-redefinition-on-glibc-2.36.patch
++ optional (targetPlatform != hostPlatform) ./libstdc++-target.patch
++ optional (atLeast7 && !atLeast10 && targetPlatform.isNetBSD) ./libstdc++-netbsd-ctypes.patch
++ optional (noSysDirs) (if atLeast12 then ./gcc-12-no-sys-dirs.patch else ./no-sys-dirs.patch)
++ optionals (is6 && langAda) [
  ./gnat-cflags.patch
  ./6/gnat-glibc234.patch
] ++ optional (noSysDirs && atLeast10 && !atLeast13 && (is10 || (!atLeast12 -> hostPlatform.isRiscV))) ./no-sys-dirs-riscv.patch
++ optional (noSysDirs && is13) ./13/no-sys-dirs-riscv.patch
++ optional (noSysDirs && is9 && hostPlatform.isRiscV) ./no-sys-dirs-riscv-gcc9.patch
++ optionals (langAda || atLeast12) [
  ./gnat-cflags-11.patch
] ++ optionals (langAda && (is9 || is10)) [
  ./gnat-cflags.patch
] ++ optionals atLeast12 [
  ./gcc-12-gfortran-driving.patch
  ./ppc-musl.patch
] ++ optionals is12 [
  # backport ICE fix on ccache code
  ./12/lambda-ICE-PR109241.patch
]
# We only apply this patch when building a native toolchain for aarch64-darwin, as it breaks building
# a foreign one: https://github.com/iains/gcc-12-branch/issues/18
++ optionals (stdenv.isDarwin && stdenv.isAarch64 && buildPlatform == hostPlatform && hostPlatform == targetPlatform) ({
  "13" = [ (fetchpatch {
    name = "gcc-13-darwin-aarch64-support.patch";
    url = "https://raw.githubusercontent.com/Homebrew/formula-patches/3c5cbc8e9cf444a1967786af48e430588e1eb481/gcc/gcc-13.2.0.diff";
    sha256 = "sha256-Y5r3U3dwAFG6+b0TNCFd18PNxYu2+W/5zDbZ5cHvv+U=";
  }) ];
  "12" = [ (fetchurl {
    name = "gcc-12-darwin-aarch64-support.patch";
    url = "https://raw.githubusercontent.com/Homebrew/formula-patches/f1188b90d610e2ed170b22512ff7435ba5c891e2/gcc/gcc-12.3.0.diff";
    sha256 = "sha256-naL5ZNiurqfDBiPSU8PTbTmLqj25B+vjjiqc4fAFgYs=";
  }) ];
}."${majorVersion}" or [])
++ optional (atLeast9 && langD) ./libphobos.patch
++ optional (is7 && hostPlatform != buildPlatform) (fetchpatch { # XXX: Refine when this should be applied
  url = "https://git.busybox.net/buildroot/plain/package/gcc/7.1.0/0900-remove-selftests.patch?id=11271540bfe6adafbc133caf6b5b902a816f5f02";
  sha256 = "0mrvxsdwip2p3l17dscpc1x8vhdsciqw1z5q9i6p5g9yg1cqnmgs";
})
++ optional (!atLeast12 && langFortran) ./gfortran-driving.patch
++ optional (!atLeast49 && hostPlatform.isDarwin) ./gfortran-darwin-NXConstStr.patch
++ optionals (is49) [
  # glibc-2.26
  ./struct-ucontext.patch
  ./struct-sigaltstack-4.9.patch
]
# TODO: deduplicate this with copy above -- leaving duplicated for now in order to avoid changing eval results by reordering
++ optional (atLeast7 && !atLeast12 && targetPlatform.libc == "musl" && targetPlatform.isPower) ./ppc-musl.patch
++ optional ((is6 || is7) && targetPlatform.libc == "musl" && targetPlatform.isx86_32) (fetchpatch {
  url = "https://git.alpinelinux.org/aports/plain/main/gcc/gcc-6.1-musl-libssp.patch?id=5e4b96e23871ee28ef593b439f8c07ca7c7eb5bb";
  sha256 = "1jf1ciz4gr49lwyh8knfhw6l5gvfkwzjy90m7qiwkcbsf4a3fqn2";
})
++ optional ((is6 || is7 || is8) && !atLeast9 && targetPlatform.libc == "musl") ./libgomp-dont-force-initial-exec.patch
++ optional (is6 && langGo) ./gogcc-workaround-glibc-2.36.patch
# TODO: deduplicate this with copy above -- leaving duplicated for now in order to avoid changing eval results by reordering
++ optionals (is11 && stdenv.isDarwin) [
  (fetchpatch {
    # There are no upstream release tags in https://github.com/iains/gcc-11-branch.
    # ff4bf32 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-11.4.0
    url = "https://github.com/iains/gcc-11-branch/compare/ff4bf326d03e750a8d4905ea49425fe7d15a04b8..gcc-11.4-darwin-r0.diff";
    hash = "sha256-6prPgR2eGVJs7vKd6iM1eZsEPCD1ShzLns2Z+29vlt4=";
  })
]
# https://github.com/osx-cross/homebrew-avr/issues/280#issuecomment-1272381808
++ optional (is11 && stdenv.isDarwin && targetPlatform.isAvr) ./avr-gcc-11.3-darwin.patch

# backport fixes to build gccgo with musl libc
++ optionals (atLeast12 && langGo && stdenv.hostPlatform.isMusl) [
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

# Fix detection of bootstrap compiler Ada support (cctools as) on Nix Darwin
++ optional (atLeast12 && stdenv.isDarwin && langAda) ./ada-cctools-as-detection-configure.patch

# Use absolute path in GNAT dylib install names on Darwin
++ optional (atLeast12 && stdenv.isDarwin && langAda) ./gnat-darwin-dylib-install-name.patch

# Obtain latest patch with ../update-mcfgthread-patches.sh
++ optional (atLeast6 && !atLeast13 && !withoutTargetLibc && targetPlatform.isMinGW && threadsCross.model == "mcf")
  (./. + "/${majorVersion}/Added-mcf-thread-model-support-from-mcfgthread.patch")

# Retpoline patches pulled from the branch hjl/indirect/gcc-4_9-branch (by H.J. Lu, the author of GCC upstream retpoline commits)
++ optionals is49
  (builtins.map ({commit, sha256}: fetchpatch {url = "https://github.com/hjl-tools/gcc/commit/${commit}.patch"; inherit sha256;})
  [{ commit = "e623d21608e96ecd6b65f0d06312117d20488a38"; sha256 = "1ix8i4d2r3ygbv7npmsdj790rhxqrnfwcqzv48b090r9c3ij8ay3"; }
   { commit = "2015a09e332309f12de1dadfe179afa6a29368b8"; sha256 = "0xcfs0cbb63llj2gbcdrvxim79ax4k4aswn0a3yjavxsj71s1n91"; }
   { commit = "6b11591f4494f705e8746e7d58b7f423191f4e92"; sha256 = "0aydyhsm2ig0khgbp27am7vq7liyqrq6kfhfi2ki0ij0ab1hfbga"; }
   { commit = "203c7d9c3e9cb0f88816b481ef8e7e87b3ecc373"; sha256 = "0wqn16y7wy5kg8ngfcni5qdwfphl01axczibbk49bxclwnzvldqa"; }
   { commit = "f039c6f284b2c9ce97c8353d6034978795c4872e"; sha256 = "13fkgdb17lpyxfksz1zanxhgpsm0jrss9w61nbl7an4im22hz7ci"; }
   { commit = "ed42606bdab1c5d9e5ad828cd6fe1a0557f193b7"; sha256 = "0gdnn8v3p03imj3qga2mzdhpgbmjcklkxdl97jvz5xia2ikzknxm"; }
   { commit = "5278e062ef292fd2fbf987d25389785f4c5c0f99"; sha256 = "0j81x758wf8v7j4rx5wc1cy7yhkvhlhv3wmnarwakxiwsspq0vrs"; }
   { commit = "76f1ffbbb6cd9f6ecde6c82cd16e20a27242e890"; sha256 = "1py56y6gp7fjf4f8bbsfwh5bs1gnmlqda1ycsmnwlzfm0cshdp0c"; }
   { commit = "4ca48b2b688b135c0390f54ea9077ef10aedd52c"; sha256 = "15r019pzr3k0lpgyvdc92c8fayw8b5lrzncna4bqmamcsdz7vsaw"; }
   { commit = "98c7bf9ddc80db965d69d61521b1c7a1cec32d9a"; sha256 = "1d7pfdv1q23nf0wadw7jbp6d6r7pnzjpbyxgbdfv7j1vr9l1bp60"; }
   { commit = "3dc76b53ad896494ca62550a7a752fecbca3f7a2"; sha256 = "0jvdzfpvfdmklfcjwqblwq1i22iqis7ljpvm7adra5d7zf2xk7xz"; }
   { commit = "1e961ed49b18e176c7457f53df2433421387c23b"; sha256 = "04dnqqs4qsvz4g8cq6db5id41kzys7hzhcaycwmc9rpqygs2ajwz"; }
   { commit = "e137c72d099f9b3b47f4cc718aa11eab14df1a9c"; sha256 = "1ms0dmz74yf6kwgjfs4d2fhj8y6mcp2n184r3jk44wx2xc24vgb2"; }])

++ optional (atLeast49 && !atLeast9) ./libsanitizer-no-cyclades-9.patch
++ optional (is49 && !atLeast6) [
  # gcc-11 compatibility
  (fetchpatch {
    name = "gcc4-char-reload.patch";
    url = "https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff_plain;h=d57c99458933a21fdf94f508191f145ad8d5ec58";
    includes = [ "gcc/reload.h" ];
    sha256 = "sha256-66AMP7/ajunGKAN5WJz/yPn42URZ2KN51yPrFdsxEuM=";
  })
]

# openjdk build fails without this on -march=opteron; is upstream in gcc12
++ optionals (is11) [ ./11/gcc-issue-103910.patch ]

++ optional (is10 && buildPlatform.system == "aarch64-darwin" && targetPlatform != buildPlatform) (fetchpatch {
  url = "https://raw.githubusercontent.com/richard-vd/musl-cross-make/5e9e87f06fc3220e102c29d3413fbbffa456fcd6/patches/gcc-${version}/0008-darwin-aarch64-self-host-driver.patch";
  sha256 = "sha256-XtykrPd5h/tsnjY1wGjzSOJ+AyyNLsfnjuOZ5Ryq9vA=";
})
++ lib.optionals is48 [
  (fetchpatch {
    name = "libc_name_p.diff"; # needed to build with gcc6
    url = "https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff_plain;h=ec1cc0263f1";
    sha256 = "01jd7pdarh54ki498g6sz64ijl9a1l5f9v8q2696aaxalvh2vwzl";
    excludes = [ "gcc/cp/ChangeLog" ];
  })
  # glibc-2.26
  ./struct-ucontext-4.8.patch
  ./sigsegv-not-declared.patch
  ./res_state-not-declared.patch
  # gcc-11 compatibility
  (fetchpatch {
    name = "gcc4-char-reload.patch";
    url = "https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff_plain;h=d57c99458933a21fdf94f508191f145ad8d5ec58";
    includes = [ "gcc/reload.h" ];
    sha256 = "sha256-66AMP7/ajunGKAN5WJz/yPn42URZ2KN51yPrFdsxEuM=";
  })
]
