{ stdenv, fetchurl, lib, cmake, perl, qt4, kdelibs, pciutils, libraw1394
, kdebase_workspace
, automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdebase-4.3.5.tar.bz2;
    sha256 = "04qm3gfz51iwwl8819fzyyjwyf6lk9nim13cp2l5abnfza0lhb9g";
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
