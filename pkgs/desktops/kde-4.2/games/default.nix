{stdenv, fetchurl, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdegames-4.2.0.tar.bz2;
    md5 = "68cefd627025be99ba136e5a4e35e554";
  };
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
}
