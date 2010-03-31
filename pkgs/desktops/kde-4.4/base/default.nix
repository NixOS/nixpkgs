{ stdenv, fetchurl, lib, cmake, perl, qt4, kdelibs, pciutils, libraw1394
, kdebase_workspace
, automoc4, phonon, strigi, qimageblitz, soprano}:

stdenv.mkDerivation {
  name = "kdebase-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdebase-4.4.2.tar.bz2;
    sha256 = "1bf75y7barmymaf810n66qf47jfrn1vfqpqn5rsls8r8wjcz0j71";
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
