{stdenv, fetchurl, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdegames-4.2.1.tar.bz2;
    sha1 = "dee8a0fece054bc3b6234fa088ca16b8f5f87795";
  };
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
}
