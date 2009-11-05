{ stdenv, fetchurl, lib, cmake, perl, qt4, kdelibs, pciutils, libraw1394
, kdebase_workspace
, automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdebase-4.3.3.tar.bz2;
    sha1 = "57ihndwiq8nx5v964s0b8q9965sylnbl";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake perl qt4 kdelibs pciutils stdenv.gcc.libc libraw1394
                  kdebase_workspace automoc4 phonon strigi qimageblitz soprano ];
  meta = {
    description = "KDE Base components";
    longDescription = "Applications that form the KDE desktop, like Plasma, System Settings, Konqueror, Dolphin, Kate, and Konsole";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
