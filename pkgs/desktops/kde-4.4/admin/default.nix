{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.4.1";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdeadmin-4.4.1.tar.bz2;
    sha256 = "0dl9ffc3c8kaw2hharli9c3b7r5s1pqzndx89p36yqciril88mh2";
  };
  
  builder = ./builder.sh;
  
  inherit system_config_printer;
  
  PYTHONPATH = "${pycups}/lib/python2.6/site-packages";
  
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups rhpl system_config_printer
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
                  
  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
