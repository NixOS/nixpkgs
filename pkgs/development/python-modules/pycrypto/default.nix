{ stdenv, fetchurl, python, gmp }:

# TODO: Update to version 2.1.0 ASAP. The update works, but as of 2010-07-28
#       the download site appears to be down.

stdenv.mkDerivation rec {
  name = "pycrypto-2.0.1";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pycrypto/${name}.tar.gz";
    sha256 = "2dff97ae70b6811157b516bf633405d09147ee1e2bfa06b0c657ad2c22de5800";
  };

  buildInputs = [ python gmp ];

  buildPhase = "true";

  installPhase =
    ''
      python ./setup.py build_ext --library-dirs=${gmp}/lib
      python ./setup.py install --prefix=$out
    '';

  meta = {
    homepage = "http://www.pycrypto.org/";
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.linux;
  };
}
