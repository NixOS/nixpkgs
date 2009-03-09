{stdenv, fetchurl, cmake, qt4, pkgconfig, perl, python,
 sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdeadmin-4.2.1.tar.bz2;
    sha1 = "888203103fe86010461b1e38d51ba9a20f3250e8";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
}
