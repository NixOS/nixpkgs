{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdegames-4.4.0.tar.bz2;
    sha256 = "1kg9xnl2vw43wmz2k6pcinp9rs7nfx5r4dmmir5m827xmxr8p9d0";
  };
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
