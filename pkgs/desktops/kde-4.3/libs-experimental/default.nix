{stdenv, fetchurl, lib, cmake, qt4, perl, automoc4, kdelibs, phonon}:

stdenv.mkDerivation {
  name = "kdelibs-experimental-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdelibs-experimental-4.3.5.tar.bz2;
    sha256 = "01sask8wa8067bhjxrvxlrfrxnvczf3w3404vc77l201xp0zsiz7";
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
