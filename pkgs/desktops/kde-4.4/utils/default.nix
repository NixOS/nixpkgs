{ stdenv, fetchurl, lib, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebase, kdebindings, automoc4, phonon, qimageblitz, qca2}:

stdenv.mkDerivation {
  name = "kdeutils-4.4.1";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdeutils-4.4.1.tar.bz2;
    sha256 = "04kcacj2b8k9vzs526kg6azhab44mgr4kwafl2pjnf7rf3hlpndv";
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
