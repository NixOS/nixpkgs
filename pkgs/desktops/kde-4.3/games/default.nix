{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdegames-4.3.5.tar.bz2;
    sha256 = "1hl3m51awn6rz3z181sawbjw824d87r9c1rswdy7365szhsr7m66";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
