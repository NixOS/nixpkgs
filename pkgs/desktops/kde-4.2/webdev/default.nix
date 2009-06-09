{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost,
 kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdewebdev-4.2.4.tar.bz2;
    sha1 = "9e3667c994793232177a70ff0b6fb2caa252757f";
  };
  includeAllQtLibs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
}
