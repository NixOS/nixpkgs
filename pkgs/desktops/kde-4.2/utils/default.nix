{stdenv, fetchurl, cmake, qt4, perl, gmp, python, libzip, libarchive, sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeutils-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdeutils-4.2.3.tar.bz2;
    sha1 = "3c312d12b75f1064085ee4ea200a5f7278bce0e0";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon qimageblitz ];
}
