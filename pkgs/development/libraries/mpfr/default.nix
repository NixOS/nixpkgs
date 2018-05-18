{ stdenv, fetchurl, gmp
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "mpfr-3.1.6";

  src = fetchurl {
    url = "mirror://gnu/mpfr/${name}.tar.xz";
    sha256 = "0l598h9klpgkz2bp0rxiqb90mkqh9f2f81n5rpy191j00hdaqqks";
  };

  outputs = [ "out" "dev" "doc" "info" ];

  # mpfr.h requires gmp.h
  propagatedBuildInputs = [ gmp ];

  configureFlags =
    stdenv.lib.optional hostPlatform.isSunOS "--disable-thread-safe" ++
    stdenv.lib.optional hostPlatform.is64bit "--with-pic";

  doCheck = true; # not cross;

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
