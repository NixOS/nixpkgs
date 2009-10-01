{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdeaccessibility-4.3.1.tar.bz2;
    sha1 = "bc9c56beb161ddf6c1474d356360ec75db0733bc";
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
