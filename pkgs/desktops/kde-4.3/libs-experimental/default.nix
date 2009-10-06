{stdenv, fetchurl, lib, cmake, qt4, perl, automoc4, kdelibs, phonon}:

stdenv.mkDerivation {
  name = "kdelibs-experimental-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/kdelibs-experimental-4.3.2.tar.bz2;
    sha1 = "0mbq3gwan0jga2vaw308zjnwkzzlrqvr";
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
