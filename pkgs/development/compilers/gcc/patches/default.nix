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
  buildIsHost,
  hostIsTarget,
}:

let
  atLeast15 = lib.versionAtLeast version "15";
  atLeast14 = lib.versionAtLeast version "14";
  is15 = majorVersion == "15";
  is14 = majorVersion == "14";
  is13 = majorVersion == "13";

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
      "16" = [
        # Do not try looking for binaries and libraries in /lib and /usr/lib
        ./13/no-sys-dirs-riscv.patch
        # Mangle the nix store hash in __FILE__ to prevent unneeded runtime references
        #
        # TODO: Remove these and the `useMacroPrefixMap` conditional
        # in `cc-wrapper` once <https://gcc.gnu.org/PR111527>
        # is fixed.
        ./13/mangle-NIX_STORE-in-__FILE__.patch
      ];
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
        ./13/libsanitizer-fix-with-glibc-2.42.patch
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
++ optional (atLeast14 && !targetPlatform.isDarwin) ./cfi_startproc-reorder-label-14-1.diff
# c++tools: Don't check --enable-default-pie.
# --enable-default-pie breaks bootstrap gcc otherwise, because libiberty.a is not found
++ optional (is14 || is15) ./c++tools-dont-check-enable-default-pie.patch

## 2. Patches relevant on specific platforms ####################################

## Darwin

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
++ optionals targetPlatform.isDarwin (
  {
    "15" = [
      # Fix libgcc_s.1.dylib build on Darwin 11+ by not reexporting unwind symbols that don't exist
      ./15/libgcc-darwin-fix-reexport.patch
      # Patches from https://github.com/iains/gcc-15-branch
      (fetchpatch {
        name = "gcc-15-darwin-aarch64-support.patch";
        url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/70e2a9e1d072fa3bc34cf41d97f4b65bede2b01e/Patches/gcc/gcc-15.3.0.diff";
        hash = "sha256-PeAloBdUu+zRJlv86Z4x/FI8I7LiR5CJ3JlAJKs1iKU=";
      })
      # Fixes detection of Darwin deployment target.
      ./15/libgcc-darwin-detection.patch
    ];
    "14" = [
      # Patches from https://github.com/iains/gcc-14-branch
      (fetchpatch {
        name = "gcc-14-darwin-aarch64-support.patch";
        url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/d23df58f83aeb2c3f43bdcc277a9fac0bbe3e896/Patches/gcc/gcc-14.4.0.diff";
        hash = "sha256-NU95q0xkP4wEi6XLJRWEhcMcL49gDuIHgZubC05QzRE=";
      })
      ./14/libgcc-darwin-detection.patch
    ];
    "13" = [
      # Patches from https://github.com/iains/gcc-13-branch
      (fetchpatch {
        name = "gcc-13-darwin-aarch64-support.patch";
        url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/d23df58f83aeb2c3f43bdcc277a9fac0bbe3e896/Patches/gcc/gcc-13.4.0.diff";
        hash = "sha256-xqkBDFYZ6fdowtqR3kV7bR8a4Cu11RDokSzGn1k3a1w=";
      })
    ];
  }
  .${majorVersion} or [ ]
)

++ optional (targetPlatform.isWindows || targetPlatform.isCygwin) (fetchpatch {
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
  (fetchpatch {
    name = "cygwin-use-builtin_define_std-for-unix.patch";
    url = "https://inbox.sourceware.org/gcc-patches/20250922182808.2599390-3-corngood@gmail.com/raw";
    hash = "sha256-8I2G4430gkYoWgUued4unqhk8ZCajHf1dcivAeuLZ0E=";
  })
]
++ optional (targetPlatform.isMusl && targetPlatform.isx86_32) ./libssp-noshared-musl32.patch
