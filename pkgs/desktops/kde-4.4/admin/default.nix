{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.4.4";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdeadmin-4.4.4.tar.bz2;
    sha256 = "04jyvnwv8xwzchvzgns2db4bhr0fxis98am58icz6qva9nsgr6zh";
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
