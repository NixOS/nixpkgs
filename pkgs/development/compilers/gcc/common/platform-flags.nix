{ lib, targetPlatform }:

let
  p =  targetPlatform.gcc or {}
    // targetPlatform.parsed.abi;
in lib.concatLists [
  (lib.optional (!targetPlatform.isx86_64 && p ? arch) "--with-arch=${p.arch}") # --with-arch= is unknown flag on x86_64
  (lib.optional (p ? cpu) "--with-cpu=${p.cpu}")
  (lib.optional (p ? abi) "--with-abi=${p.abi}")
  (lib.optional (p ? fpu) "--with-fpu=${p.fpu}")
  (lib.optional (p ? float) "--with-float=${p.float}")
  (lib.optional (p ? mode) "--with-mode=${p.mode}")

  # The powerpc64 ABI has an IBM-specific, non-IEEE "long double" type
  # which causes many some test failures.  GCC and glibc have been
  # working on migrating to 128-bit IEEE long doubles using a complex
  # "fat binary" scheme that avoids having a new multiarch tuple.
  # Progress with this scheme has been exceptionally slow: Fedora has
  # been trying to "flip the switch" since Fedora 31 without success.
  #
  # As of version 2.34 glibc refuses to build using *only* the IEEE
  # standard long-double type, and implementation of the "fat binary"
  # scheme to support both IEEE and IBM long doubles simultaneously is
  # troublesome and unreliable.  Therefore, we use the same approach
  # with glibc that musl uses: simply have `long double` be the same
  # size as `double`: 64 bits.  This is already the case on
  # aarch64-darwin, 32-bit ARM, 32-bit MIPS, and Microsoft's C/C++
  # compiler for both 64-bit ARM and 32-bit x86, so it is
  # well-supported by the build scripts for essentially everything in
  # nixpkgs.
  #
  # Musl specifically checks for non-IEEE `long double`s on powerpc
  # and will refuse to build if they are found to be present:
  #
  #   https://git.musl-libc.org/cgit/musl/tree/configure#n732
  #
  # This has saved musl as great deal of trouble that glibc is
  # currently struggling with.  By using the same approach for both
  # musl and glibc we avoid a lot of headaches that come up when
  # "cross-compiling" from *-linux-gnu to *-linux-musl due to the
  # libgcc bundled into *-linux-gnu's being linked with the emitted
  # binaries.
  #
  # More details:
  #
  #   https://gcc.gnu.org/wiki/Ieee128PowerPC
  #   https://gcc.gnu.org/onlinedocs/gcc/Floating-Types.html
  #   https://fedoraproject.org/wiki/Changes/PPC64LE_Float128_Transition
  #   https://en.m.wikipedia.org/wiki/Long_double
  #   https://gcc.gnu.org/install/configure.html
  #
  # Below are the three possible valid combinations of options, with
  # two commented out:
  #
  (lib.optionals targetPlatform.isPower64 [ "--without-long-double-128" "--with-long-double-64" ])
]
