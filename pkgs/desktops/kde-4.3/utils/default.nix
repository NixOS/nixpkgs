{ stdenv, fetchurl, lib, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, system_config_printer, rhpl
, kdelibs, kdelibs_experimental, kdepimlibs, kdebase, kdebindings, automoc4, phonon, qimageblitz, qca2}:

stdenv.mkDerivation {
  name = "kdeutils-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdeutils-4.3.1.tar.bz2;
    sha1 = "9743636306cfb137241b6c87f5944e6bf91870fe";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive xz sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdelibs_experimental kdepimlibs kdebase kdebindings automoc4 phonon qimageblitz qca2 ];
  meta = {
    description = "KDE Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
