{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdegames-4.3.4.tar.bz2;
    sha1 = "33ea8ec476b1557a55c90c071bd462e5ceb7c52b";
  };
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
