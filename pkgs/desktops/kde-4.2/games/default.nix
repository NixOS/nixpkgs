{stdenv, fetchurl, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdegames-4.2.3.tar.bz2;
    sha1 = "74e0a41cdce34bead787a7c4586d3dae7aa06cc9";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
}
