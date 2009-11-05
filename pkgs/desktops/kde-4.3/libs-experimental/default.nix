{stdenv, fetchurl, lib, cmake, qt4, perl, automoc4, kdelibs, phonon}:

stdenv.mkDerivation {
  name = "kdelibs-experimental-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdelibs-experimental-4.3.3.tar.bz2;
    sha1 = "5fhzsmpmhpzn923rg25dk9siqpmqzab8";
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
