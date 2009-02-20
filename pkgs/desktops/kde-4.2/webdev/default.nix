{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost,
 kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdewebdev-4.2.0.tar.bz2;
    md5 = "8b60c68f6cbbe9c5bb48caa576853f9e";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
}
