{stdenv, fetchurl, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdegames-4.2.2.tar.bz2;
    sha1 = "ffd4dde8c10f14de9da4e44d22b2ac19c8bfce9b";
  };
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
}
