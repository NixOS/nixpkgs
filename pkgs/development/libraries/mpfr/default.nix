{stdenv, fetchurl, gmp}:

stdenv.mkDerivation {
  name = "mpfr-2.4.1";

  src = fetchurl {
    url = http://www.mpfr.org/mpfr-2.4.1/mpfr-2.4.1.tar.bz2;
    sha256 = "0pj879vbwbik8xkgnxy2ll32ljq3bgqjsqapqasq9rkfbkl90a34";
  };

  buildInputs = [gmp];

  meta = {
    homepage = http://www.mpfr.org/;
    description = "GNU MPFR, a library for multiple-precision floating-point arithmetic";

    longDescription = ''
      The GNU MPFR library is a C library for multiple-precision
      floating-point computations with correct rounding.  MPFR is
      based on the GMP multiple-precision library.

      The main goal of MPFR is to provide a library for
      multiple-precision floating-point computation which is both
      efficient and has a well-defined semantics.  It copies the good
      ideas from the ANSI/IEEE-754 standard for double-precision
      floating-point arithmetic (53-bit mantissa).
    '';

    license = "LGPLv2+";
  };
}
