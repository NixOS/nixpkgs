{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.4.3";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdeadmin-4.4.3.tar.bz2;
    sha256 = "08s0fagxgdk6p00qxzizrhs9010f6s9rlz7w07ri86m9ps9yd6am";
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
