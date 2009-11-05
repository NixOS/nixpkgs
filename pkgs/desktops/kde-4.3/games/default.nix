{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdegames-4.3.3.tar.bz2;
    sha1 = "2xy5wvk51rxbifwp28rgby776kwq93vz";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
