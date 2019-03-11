{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  version = "4.0.2";
  name = "mpfr-${version}";

  src = fetchurl {
    urls = [
      #"https://www.mpfr.org/${name}/${name}.tar.xz"
      "mirror://gnu/mpfr/${name}.tar.xz"
    ];
    sha256 = "12m3amcavhpqygc499s3fzqlb8f2j2rr7fkqsm10xbjfc04fffqx";
  };

  outputs = [ "out" "dev" "doc" "info" ];

  # mpfr.h requires gmp.h
  propagatedBuildInputs = [ gmp ];

  configureFlags =
    stdenv.lib.optional stdenv.hostPlatform.isSunOS "--disable-thread-safe" ++
    stdenv.lib.optional stdenv.hostPlatform.is64bit "--with-pic";

  doCheck = true; # not cross;

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.mpfr.org/;
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
