{stdenv, fetchurl, m4, cxx ? true}:

stdenv.mkDerivation rec {
  name = "gmp-4.3.1";

  src = fetchurl {
    url = "mirror://gnu/gmp/${name}.tar.bz2";
    sha256 = "1j5pklq36ivg2cim5wfysns229a544lqkimp3mlzkwjl513ra0ma";
  };

  buildInputs = [m4];

  preConfigure = "ln -sf configfsf.guess config.guess";

  configureFlags = if cxx then "--enable-cxx" else "--disable-cxx";

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "A free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers";
    homepage = http://gmplib.org/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.all;
  };
}
