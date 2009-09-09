{stdenv, fetchurl, lib, cmake, qt4, perl, automoc4, kdelibs, phonon}:

stdenv.mkDerivation {
  name = "kdelibs-experimental-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdelibs-experimental-4.3.1.tar.bz2;
    sha1 = "7d560817a186c4b7099d321ee4a58705962a59d3";
  };
  builder = ./builder.sh;
  buildInputs = [ cmake qt4 perl automoc4 kdelibs phonon ];
  includeAllQtDirs=true;
  meta = {
    description = "KDE experimental library";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
