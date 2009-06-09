{stdenv, fetchurl, cmake, qt4, perl, gmp, python, libzip, libarchive, sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeutils-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdeutils-4.2.4.tar.bz2;
    sha1 = "59bb17463bec48c77768e50fb0e9ec3c1b0827af";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon qimageblitz ];
}
