{stdenv, fetchurl, cmake, qt4, perl, gettext, apr, aprutil, subversion, db4,
 kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdesvn-1.3.0";
  src = fetchurl {
    url = http://kdesvn.alwins-world.de/downloads/kdesvn-1.3.0.tar.bz2;
    sha256 = "d219c430c98d75d07258057e78c29042777e0368eded7494499361031ac63649";
  };
  includeAllQtDirs=true;
  builder = ./builder.sh;
  inherit subversion;
  buildInputs = [ cmake qt4 perl gettext apr aprutil subversion db4 kdelibs automoc4 phonon ];
}
