{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, apr, aprutil, subversion, db4
, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdesvn-1.4.1";
  src = fetchurl {
    url = http://kdesvn.alwins-world.de/downloads/kdesvn-1.4.1.tar.bz2;
    sha256 = "1xaankj3zl1wxm1zf9dayb9qwnp9s5xx964p83w7pcsir4h5959z";
  };
  includeAllQtDirs=true;
  builder = ./builder.sh;
  inherit subversion;
  buildInputs = [ cmake qt4 perl gettext apr aprutil subversion db4 kdelibs automoc4 phonon ];
  meta = {
    description = "KDE SVN front-end";
    license = "GPL";
    homepage = http://kdesvn.alwins-world.de;
    maintainers = [ lib.maintainers.sander ];
  };
}
