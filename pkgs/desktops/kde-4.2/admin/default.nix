{stdenv, fetchurl, cmake, qt4, pkgconfig, perl, python,
 sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdeadmin-4.2.2.tar.bz2;
    sha1 = "3bf8f689d6fcafcfdfb2bea4c6003e56c80c4601";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
}
