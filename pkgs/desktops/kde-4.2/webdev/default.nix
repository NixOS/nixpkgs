{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost,
 kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdewebdev-4.2.1.tar.bz2;
    sha1 = "438bef3bb32ce53a83c6f30f65fb49d4d4e7c76a";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
}
