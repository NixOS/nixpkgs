{stdenv, fetchurl, which, qt4}:

stdenv.mkDerivation {
  name = "qca-2.0.1";
  src = fetchurl {
    url = http://delta.affinix.com/download/qca/2.0/qca-2.0.1.tar.bz2;
    md5 = "a0a87d0b3210e23f8c1713562282b7d6";
  };
  buildInputs = [ which qt4 ];
}
