{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/kdegames-4.3.2.tar.bz2;
    sha1 = "bpih92p9zmvvhxd661rbpankznbfwgnc";
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
