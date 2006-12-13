{stdenv, fetchurl, python, gmp}:

stdenv.mkDerivation {
  name = "pycrypto-2.0.1";
  src = fetchurl {
    url = http://www.amk.ca/files/python/crypto/pycrypto-2.0.1.tar.gz;
    md5 = "4d5674f3898a573691ffb335e8d749cd";
  };
  buildInputs = [python gmp];
  buildPhase = "true";
  installPhase = "
    python ./setup.py build_ext --library-dirs=${gmp}/lib
    python ./setup.py install --prefix=$out
  ";
}
