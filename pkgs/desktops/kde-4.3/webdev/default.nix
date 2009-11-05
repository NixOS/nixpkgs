{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdewebdev-4.3.3.tar.bz2;
    sha1 = "zgavpqh263vjf9ay03291dmbkqm42kzq";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
