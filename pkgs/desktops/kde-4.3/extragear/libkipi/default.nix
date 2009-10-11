{stdenv, fetchurl, lib, qt4, perl, gettext, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "libkipi-0.1.4";
  src = fetchurl {
    url = mirror://sourceforge/kipi/libkipi-0.1.4.tar.bz2;
    sha256 = "1rj98rbgam8j0ndy0si5zfqqvqdlqlcgbzi6smq27d9micfy5yn8";
  };
  includeAllQtDirs=true;
  buildInputs = [ qt4 perl gettext kdelibs automoc4 phonon ];
  meta = {
    description = "KDE Image Plugin Interface";
    license = "GPL";
    homepage = http://extragear.kde.org/apps/kipi;
  };
}
