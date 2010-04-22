{ stdenv, fetchurl, lib, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdeartwork-4.4.2.tar.bz2;
    sha256 = "1yb9p3nsayzp4vq0sq2ax0svmf6za73g4wzj3jcbs13j0gsvpz70";
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
