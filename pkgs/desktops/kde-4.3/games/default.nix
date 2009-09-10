{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdegames-4.3.1.tar.bz2;
    sha1 = "576255ce66a0c089e0840bd90ea89d5705872bc8";
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
