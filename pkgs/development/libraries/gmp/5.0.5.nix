{ stdenv, fetchurl, m4, cxx ? true }:

stdenv.mkDerivation rec {
  name = "gmp-5.0.5";

  src = fetchurl {
    url = "mirror://gnu/gmp/${name}.tar.bz2";
    sha256 = "1jfymbr90mpn0zw5sg001llqnvf2462y77vgjknrmfs1rjn8ln0z";
  };

  patches = [ ./ignore-bad-cpuid.patch ];

  buildNativeInputs = [ m4 ];

  configureFlags =
    # Build a "fat binary", with routines for several sub-architectures
    # (x86), except on Solaris where some tests crash with "Memory fault".
    # See <http://hydra.nixos.org/build/2760931>, for instance.
    (stdenv.lib.optional (!stdenv.isSunOS) "--enable-fat")
    ++ (if cxx then [ "--enable-cxx" ] else [ "--disable-cxx" ]);

  doCheck = true;

  enableParallelBuilding = true;

  crossAttrs = {
    # Disable stripping to avoid "libgmp.a: Archive has no index"
    # (see <http://hydra.nixos.org/build/4268666>.)
    dontStrip = true;
    dontCrossStrip = true;
  };

  meta = {
    description = "GMP, the GNU multiple precision arithmetic library";

    longDescription =
      '' GMP is a free library for arbitrary precision arithmetic, operating
         on signed integers, rational numbers, and floating point numbers.
         There is no practical limit to the precision except the ones implied
         by the available memory in the machine GMP runs on.  GMP has a rich
         set of functions, and the functions have a regular interface.

         The main target applications for GMP are cryptography applications
         and research, Internet security applications, algebra systems,
         computational algebra research, etc.

         GMP is carefully designed to be as fast as possible, both for small
         operands and for huge operands.  The speed is achieved by using
         fullwords as the basic arithmetic type, by using fast algorithms,
         with highly optimised assembly code for the most common inner loops
         for a lot of CPUs, and by a general emphasis on speed.

         GMP is faster than any other bignum library.  The advantage for GMP
         increases with the operand sizes for many operations, since GMP uses
         asymptotically faster algorithms.
      '';

    homepage = http://gmplib.org/;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.all;
  };
}
