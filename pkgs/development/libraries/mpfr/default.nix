{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "mpfr-3.1.2";

  src = fetchurl {
    url = "mirror://gnu/mpfr/${name}.tar.bz2";
    sha256 = "0sqvpfkzamxdr87anzakf9dhkfh15lfmm5bsqajk02h1mxh3zivr";
  };

  buildInputs = [ gmp ];

  configureFlags =
    /* Work around a FreeBSD bug that otherwise leads to segfaults in the test suite:
          http://hydra.bordeaux.inria.fr/build/34862
          http://websympa.loria.fr/wwsympa/arc/mpfr/2011-10/msg00015.html
          http://www.freebsd.org/cgi/query-pr.cgi?pr=161344
      */
    stdenv.lib.optional (stdenv.isSunOS or stdenv.isFreeBSD) "--disable-thread-safe" ++
    stdenv.lib.optional stdenv.is64bit "--with-pic";

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

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
