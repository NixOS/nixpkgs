{ stdenv, fetchurl, lib, cmake, perl, qt4, kdelibs, pciutils, libraw1394
, kdebase_workspace
, automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdebase-4.3.4.tar.bz2;
    sha1 = "7f8637367177c93916dfc2e6a2f6323a5e91c6ce";
  };
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
