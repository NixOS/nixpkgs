{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, apr, aprutil, subversion, db4
, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdesvn-1.4.0";
  src = fetchurl {
    url = http://kdesvn.alwins-world.de/downloads/kdesvn-1.4.0.tar.bz2;
    sha256 = "0rb213jybs9mgiwvphk8dhryz6q9m6qvxl1m7bqwzars48cspgl0";
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
