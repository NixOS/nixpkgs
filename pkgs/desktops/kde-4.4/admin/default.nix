{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.4.5";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdeadmin-4.4.5.tar.bz2;
    sha256 = "1jmjvjjpkcjqdxyxc4n5z3l3p4hy8par06n7xicbzx9a1mzj71wy";
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
