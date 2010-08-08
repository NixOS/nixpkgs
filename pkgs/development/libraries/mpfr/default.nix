{stdenv, fetchurl, gmp}:

stdenv.mkDerivation rec {
  name = "mpfr-2.4.2";

  src = fetchurl {
    url = "mirror://gnu/mpfr/${name}.tar.bz2";
    sha256 = "1fpjphja2ridy1wfc53mcbavj4axl28ibvnawj1217flm045mry7";
  };

  buildInputs = [ gmp ];

  doCheck = true;

  enableParallelBuilding = true;

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
