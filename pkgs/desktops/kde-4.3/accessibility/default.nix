{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdeaccessibility-4.3.3.tar.bz2;
    sha1 = "g71fn825bd3ici3vypjgnizypgv345hw";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 phonon ];
  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
