{stdenv, fetchurl, cmake, qt4, pkgconfig, perl, python,
 sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdeadmin-4.2.3.tar.bz2;
    sha1 = "7a344a8def92a7d2801afd78c8bff06187b1bd98";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
}
