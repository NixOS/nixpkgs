{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  name = "pycrypto-2.6.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pycrypto/${name}.tar.gz";
    sha256 = "0g0ayql5b9mkjam8hym6zyg6bv77lbh66rv1fyvgqb17kfc1xkpj";
  };

  buildInputs = [ python gmp ];

  buildPhase =
    ''
      python ./setup.py build_ext --library-dirs=${gmp}/lib
    '';

#  installPhase =
#    ''
#      python ./setup.py install --prefix=$out
#    '';

  meta = {
    homepage = "http://www.pycrypto.org/";
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.gnu;
  };
}
