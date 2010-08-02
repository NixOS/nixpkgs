{ stdenv, fetchurl, lib, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebase, kdebindings, automoc4, phonon, qimageblitz, qca2}:

stdenv.mkDerivation {
  name = "kdeutils-4.4.5";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdeutils-4.4.5.tar.bz2;
    sha256 = "159464yv5l0ra6h7l2ihfc3i4sr62229837zi6n9x4bfmd5pvvq7";
  };
  
  builder = ./builder.sh;
  
  inherit system_config_printer;
  
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive xz sip pyqt4 pycups rhpl system_config_printer
                  kdelibs kdepimlibs kdebase kdebindings automoc4 phonon qimageblitz qca2 ];
                  
  meta = {
    description = "KDE Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
