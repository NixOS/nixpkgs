{ stdenv, fetchurl, lib, cmake, qt4, pkgconfig, perl, python
, sip, pyqt4, pycups, system_config_printer
, kdelibs, kdepimlibs, kdebindings, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.4.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdeadmin-4.4.0.tar.bz2;
    sha256 = "10gafh9qdi3v2iinbd7a2x28fcz86sd3lyym8gd64q6qq8phgxqy";
  };
  
  builder = ./builder.sh;
  
  inherit system_config_printer;
  
  
  
  buildInputs = [ cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer
                  kdelibs kdepimlibs kdebindings automoc4 phonon ];
                  
  meta = {
    description = "KDE Administration Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
