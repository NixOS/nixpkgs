{ stdenv, fetchurl, lib, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdeartwork-4.3.1.tar.bz2;
    sha1 = "9db5c69723bdc9f203e4f854d505c0f87a6dda0d";
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
