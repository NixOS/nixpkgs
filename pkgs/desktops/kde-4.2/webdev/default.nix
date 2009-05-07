{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost,
 kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdewebdev-4.2.3.tar.bz2;
    sha1 = "737f6876d17da45e8dc855d47973ab8aa91827e3";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
}
