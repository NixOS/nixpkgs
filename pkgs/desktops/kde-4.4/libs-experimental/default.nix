{stdenv, fetchurl, lib, cmake, qt4, perl, automoc4, kdelibs, phonon}:

stdenv.mkDerivation {
  name = "kdelibs-experimental-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdelibs-experimental-4.3.4.tar.bz2;
    sha1 = "43e19c44c3cdc1049c9ee9aca2e2f83a48ffe8bd";
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
