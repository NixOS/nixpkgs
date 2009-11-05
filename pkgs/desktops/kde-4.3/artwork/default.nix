{ stdenv, fetchurl, lib, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdeartwork-4.3.3.tar.bz2;
    sha1 = "r3gpy7d7g6arb0vlnp6959ly6c5dcrbj";
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
