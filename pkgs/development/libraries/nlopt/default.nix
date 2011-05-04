{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "nlopt-2.2.1";

  src = fetchurl {
    url = "http://ab-initio.mit.edu/nlopt/${name}.tar.gz";
    sha256 = "0p7ri7dcp6vga7jwng7wj9bf2ixk6p5ldxp76r93xkrdixqfngaq";
  };

  configureFlags = "--with-cxx --with-pic --without-guile --without-python --without-octave --without-matlab";
}
