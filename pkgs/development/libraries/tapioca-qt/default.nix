{stdenv, fetchurl, cmake, qt4, telepathy_qt}:

stdenv.mkDerivation {
  name = "tapioca-qt-0.14.1";
  src = fetchurl {
    url = mirror://sourceforge/tapioca-voip/tapioca-qt-0.14.1.tar.gz;
    md5 = "169318705af6386057b537c5317d520d";
  };
  buildInputs = [ cmake qt4 telepathy_qt ];
}
