{stdenv, fetchurl, cmake, qt4, perl, gmp, python, libzip, libarchive, sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeutils-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdeutils-4.2.2.tar.bz2;
    sha1 = "98e388776b1c270fc6a629c94455024e08bb85b4";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon qimageblitz ];
}
