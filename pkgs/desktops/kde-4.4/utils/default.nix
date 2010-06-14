{ stdenv, fetchurl, lib, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebase, kdebindings, automoc4, phonon, qimageblitz, qca2}:

stdenv.mkDerivation {
  name = "kdeutils-4.4.4";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdeutils-4.4.4.tar.bz2;
    sha256 = "1vdpa360wmk6gr84xgmpfyjzf2l5dsxacyq29c6dmg6n7cziq85c";
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
