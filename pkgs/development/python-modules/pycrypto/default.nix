{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  name = "pycrypto-2.6";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pycrypto/${name}.tar.gz";
    md5 = "88dad0a270d1fe83a39e0467a66a22bb";
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
