{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "mpfr-3.1.3";

  src = fetchurl {
    url = "mirror://gnu/mpfr/${name}.tar.bz2";
    sha256 = "1z8akfw9wbmq91vrx04bw86mmnxw2sw5qm5cr8ix5b3w2mcv8fzn";
  };

  patches = [ ./upstream.patch ];

  outputs = [ "dev" "out" "doc" ];

  # mpfr.h requires gmp.h
  propagatedBuildInputs = [ gmp ];

  configureFlags =
    stdenv.lib.optional stdenv.isSunOS "--disable-thread-safe" ++
    stdenv.lib.optional stdenv.is64bit "--with-pic";

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.mpfr.org/;
    description = "Library for multiple-precision floating-point arithmetic";

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

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
