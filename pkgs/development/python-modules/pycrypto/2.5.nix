{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  name = "pycrypto-2.5";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pycrypto/${name}.tar.gz";
    md5 = "783e45d4a1a309e03ab378b00f97b291";
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
