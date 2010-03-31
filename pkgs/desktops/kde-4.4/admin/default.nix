{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, rhpl, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.4.2";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdeadmin-4.4.2.tar.bz2;
    sha256 = "0qzsfkf0gzhdzyyyfycz652ii8ivgin7zvzbkha3jz7kfbrskg9k";
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
