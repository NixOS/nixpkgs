{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  version = "4.0.1";
  name = "mpfr-${version}";

  src = fetchurl {
    url = "mirror://gnu/mpfr/${name}.tar.xz";
    sha256 = "0vp1lrc08gcmwdaqck6bpzllkrykvp06vz5gnqpyw0v3h9h4m1v7";
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
