{
  lib,
  stdenv,
  langC,
  langAda,
  langObjC,
  langObjCpp,
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
  is15 = majorVersion == "15";
  is14 = majorVersion == "14";
  is13 = majorVersion == "13";

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
#  Patches below are organized into two general categories:
#  1. Patches relevant on every platform
#  2. Patches relevant on specific platforms
#

## 1. Patches relevant on every platform ####################################

optionals noSysDirs (
  [
    # Do not try looking for binaries and libraries in /lib and /usr/lib
    ./gcc-12-no-sys-dirs.patch
  ]
  ++ (
    {
      "15" = [
        # Do not try looking for binaries and libraries in /lib and /usr/lib
        ./13/no-sys-dirs-riscv.patch
        # Mangle the nix store hash in __FILE__ to prevent unneeded runtime references
        #
        # TODO: Remove these and the `useMacroPrefixMap` conditional
        # in `cc-wrapper` once <https://gcc.gnu.org/PR111527>
        # is fixed.
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
    }
    ."${majorVersion}" or [ ]
  )
)
# Pass CFLAGS on to gnat
++ optional langAda ./gnat-cflags-11.patch
++
  optional langFortran
    # Fix interaction of gfortran and libtool
    # Fixes the output of -v
    # See also https://github.com/nixOS/nixpkgs/commit/cc6f814a8f0e9b70ede5b24192558664fa1f98a2
    ./gcc-12-gfortran-driving.patch
# Do not pass a default include dir on PowerPC+Musl
# See https://github.com/NixOS/nixpkgs/pull/45340/commits/d6bb7d45162ac93e017cc9b665ae4836f6410710
++ [ ./ppc-musl.patch ]
# Moves the .cfi_starproc instruction to after the function label
# Needed to build llvm-18 and later
# See https://github.com/NixOS/nixpkgs/pull/354107/commits/2de1b4b14e17f42ba8b4bf43a29347c91511e008
++ optional (!atLeast14) ./cfi_startproc-reorder-label-09-1.diff
++ optional (atLeast14 && !canApplyIainsDarwinPatches) ./cfi_startproc-reorder-label-14-1.diff

## 2. Patches relevant on specific platforms ####################################

### Musl+Go+gcc12

# backport fixes to build gccgo with musl libc
++ optionals (stdenv.hostPlatform.isMusl && langGo) [
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
++ optional (stdenv.hostPlatform.isDarwin && langAda) ./ada-cctools-as-detection-configure.patch

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
        hash = "sha256-MJxSGv6LEP1sIM8cDqbmfUV7byV0bYgADeIBY/Teyu8=";
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
        url = "https://raw.githubusercontent.com/Homebrew/formula-patches/698885df7f624d0ce15bceb79a4d9760a473b502/gcc/gcc-13.4.0.diff";
        hash = "sha256-xqkBDFYZ6fdowtqR3kV7bR8a4Cu11RDokSzGn1k3a1w=";
      })
    ];
  }
  .${majorVersion} or [ ]
)

++ optional targetPlatform.isCygwin (fetchpatch {
  name = "libstdc-fix-compilation-in-freestanding-win32.patch";
  url = "https://inbox.sourceware.org/gcc-patches/20250922182808.2599390-2-corngood@gmail.com/raw";
  hash = "sha256-+EYW9lG8CviVX7RyNHp+iX+8BRHUjt5b07k940khbbY=";
})

++ optionals targetPlatform.isCygwin [
  (fetchpatch {
    name = "cygwin-fix-compilation-with-inhibit_libc.patch";
    url = "https://inbox.sourceware.org/gcc-patches/20250926170154.2222977-1-corngood@gmail.com/raw";
    hash = "sha256-mgzMRvgPdhj+Q2VRsFhpE2WQzg0CvWsc5/FRAsSU1Es=";
  })
]
