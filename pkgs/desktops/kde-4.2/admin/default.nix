{stdenv, fetchurl, cmake, qt4, pkgconfig, perl, python,
 sip, pyqt4, pycups, system_config_printer, rhpl,
 kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdeadmin-4.2.4.tar.bz2;
    sha1 = "72a9bfeaacf6bf70f464923f96b28891ad6b671e";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
}
