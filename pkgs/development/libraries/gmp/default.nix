{stdenv, fetchurl, m4, cxx ? true}:

stdenv.mkDerivation rec {
  name = "gmp-5.0.1";

  src = fetchurl {
    url = "mirror://gnu/gmp/${name}.tar.bz2";
    sha256 = "1yrr14l6vvhm1g27y8nb3c75j0i4ii4k1gw7ik08safk3zq119m2";
  };

  buildNativeInputs = [m4];

  # Prevent the build system from using sub-architecture-specific
  # instructions (e.g., SSE2 on i686).
  preConfigure = "ln -sf configfsf.guess config.guess";

  configureFlags = if cxx then "--enable-cxx" else "--disable-cxx";

  doCheck = true;

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

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
