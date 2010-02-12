{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.3.4";
  
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdeadmin-4.3.4.tar.bz2;
    sha1 = "8f61aeb2ff9d51712d72cd77dad837c8902b6a5d";
  };
  
  builder = ./builder.sh;
  
  inherit system_config_printer;
  
  
  CMAKE_PREFIX_PATH=kdepimlibs;
  
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
                  
  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
