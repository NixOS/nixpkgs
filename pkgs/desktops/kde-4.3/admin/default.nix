{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.3.5";
  
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdeadmin-4.3.5.tar.bz2;
    sha256 = "131w41rpxzg96pv0bdxjzvm0jhsziric3gd3fq26by4b8i662r9l";
  };
  
  builder = ./builder.sh;
  
  inherit system_config_printer;
  
  includeAllQtDirs=true;
  
  
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
                  
  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
