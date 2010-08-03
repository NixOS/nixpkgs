{ stdenv, fetchurl, lib, cmake, perl, qt4, kdelibs, pciutils, libraw1394
, kdebase_workspace
, automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdebase-4.4.5.tar.bz2;
    sha256 = "1q3bmpskrfqddyywn895xdp9p53hbd7siabvla7w6z35azi9fpn9";
  };
  buildInputs = [ cmake perl qt4 kdelibs pciutils stdenv.gcc.libc libraw1394
                  kdebase_workspace automoc4 phonon strigi qimageblitz soprano ];
  meta = {
    description = "KDE Base components";
    longDescription = "Applications that form the KDE desktop, like Plasma, System Settings, Konqueror, Dolphin, Kate, and Konsole";
    license = "GPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers platforms;
  };
}
