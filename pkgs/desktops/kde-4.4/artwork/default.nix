{ stdenv, fetchurl, lib, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdeartwork-4.4.3.tar.bz2;
    sha256 = "0ivfqg9nr5lqa1dppc0p6aw816jy8zqj308dv367jqh1qbapx0cl";
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
