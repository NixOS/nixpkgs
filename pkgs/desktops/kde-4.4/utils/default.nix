{ stdenv, fetchurl, lib, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, system_config_printer
, kdelibs, kdelibs_experimental, kdepimlibs, kdebase, kdebindings, automoc4, phonon, qimageblitz, qca2}:

stdenv.mkDerivation {
  name = "kdeutils-4.3.4";
  
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdeutils-4.3.4.tar.bz2;
    sha1 = "2d5e26055e364af2df7459cdbc3aebdc3a8abdea";
  };
  
  builder = ./builder.sh;
  
  inherit system_config_printer;
  
  
  CMAKE_PREFIX_PATH=kdepimlibs;
  
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive xz sip pyqt4 pycups system_config_printer
                  kdelibs kdelibs_experimental kdepimlibs kdebase kdebindings automoc4 phonon qimageblitz qca2 ];
                  
  meta = {
    description = "KDE Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
