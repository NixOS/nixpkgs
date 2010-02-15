{ stdenv, fetchurl, lib, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdeartwork-4.3.5.tar.bz2;
    sha256 = "07s1s5rdy5nmfll6dvnrpv3byx7zvflsqzffhlm7fsx7hy1m4cbq";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl xscreensaver
                  kdelibs kdebase_workspace automoc4 phonon strigi eigen ];
  meta = {
    description = "KDE artwork";
    longDescription = "Contains various artwork for KDE such as backgrounds, icons and screensavers";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
