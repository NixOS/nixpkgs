{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost,
 kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdewebdev-4.2.2.tar.bz2;
    sha1 = "fe43dad60a72bcaaafa0d0384fa5635c6a9c4795";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
}
