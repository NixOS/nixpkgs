{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, system_config_printer, rhpl
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdeadmin-4.3.3.tar.bz2;
    sha1 = "xaps0gpjv68gn9d2vw3iq0568yxk1ilh";
  };
  builder = ./builder.sh;
  inherit system_config_printer;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer rhpl
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
