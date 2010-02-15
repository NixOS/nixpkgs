{ stdenv, fetchurl, lib, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, system_config_printer
, kdelibs, kdelibs_experimental, kdepimlibs, kdebase, kdebindings, automoc4, phonon, qimageblitz, qca2}:

stdenv.mkDerivation {
  name = "kdeutils-4.3.5";
  
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdeutils-4.3.5.tar.bz2;
    sha256 = "0c19yx1z1mdz1mzhpwic5k9wkk6j0ahmsc9swkfr05j5fbnjvzn7";
  };
  
  builder = ./builder.sh;
  
  inherit system_config_printer;
  
  includeAllQtDirs=true;
  
  
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive xz sip pyqt4 pycups system_config_printer
                  kdelibs kdelibs_experimental kdepimlibs kdebase kdebindings automoc4 phonon qimageblitz qca2 ];
                  
  meta = {
    description = "KDE Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
