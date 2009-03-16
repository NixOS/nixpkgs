{stdenv, fetchurl, cmake, qt4}:

stdenv.mkDerivation {
  name = "telepathy-qt-0.14.1";
  src = fetchurl {
    url = mirror://sourceforge/tapioca-voip/telepathy-qt-0.14.1.tar.gz;
    md5 = "476e3fbd68b3eaf5354559be7de99333";
  };
  buildInputs = [ cmake qt4 ];
}
