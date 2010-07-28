{ stdenv, fetchurl, python, gmp }:

stdenv.mkDerivation rec {
  name = "pycrypto-2.1.0";

  src = fetchurl {
    url = "http://www.pycrypto.org/files/${name}.tar.gz";
    sha256 = "18nq49l8wplg54hz9h26n61rq49vjzmy5xzlkm1g0j82x8i1qgi5";
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
