{ stdenv, fetchurl, lib, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdeartwork-4.4.5.tar.bz2;
    sha256 = "1m12rj83wp36a3ii8frx52jk7hi7g8rb451n4g9hg5rdbllcfs93";
  };
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
