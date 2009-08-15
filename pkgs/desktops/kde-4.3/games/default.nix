{stdenv, fetchurl, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdegames-4.2.4.tar.bz2;
    sha1 = "c940d73616734fabdfcd0c5961459ba168494b16";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
}
