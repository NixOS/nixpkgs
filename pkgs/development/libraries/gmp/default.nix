{stdenv, fetchurl, m4, cxx ? true }:

stdenv.mkDerivation {
  name = "gmp-4.2.3";

  src = fetchurl {
    url = mirror://gnu/gmp/gmp-4.2.3.tar.bz2;
    sha256 = "139b5abc49833832184c0a03ff6fc64c59ef102b420d2a5884ad78af5647414b";
  };

  buildInputs = [m4 stdenv.gcc.libc ];
  configureFlags = if cxx then "--enable-cxx" else "--disable-cxx";
  doCheck = true;
  postBuild = "make check";  # Test the compiler for being correct

  meta = {
    description = "A free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers";
    homepage = http://gmplib.org/;
    license = "LGPL";
  };
}
