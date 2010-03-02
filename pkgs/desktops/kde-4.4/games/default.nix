{stdenv, fetchurl, lib, cmake, qt4, perl, shared_mime_info, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.4.1";
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdegames-4.4.1.tar.bz2;
    sha256 = "13xk7anmnq4lprcqahy7q6nn7b0j8mnyy070jyafzgmc5ncvylfd";
  };
  buildInputs = [ cmake qt4 perl shared_mime_info kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
