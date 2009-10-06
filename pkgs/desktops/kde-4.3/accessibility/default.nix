{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/kdeaccessibility-4.3.2.tar.bz2;
    sha1 = "63pn3kaqipn7mmibw042ijvlz8y2vapn";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl alsaLib libXtst kdelibs automoc4 phonon ];
  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
