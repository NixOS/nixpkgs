{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdeaccessibility-4.3.5.tar.bz2;
    sha256 = "00h89gnxsl1d01ib4rvszmm8vgbhg6q14bvd5gl3ibssyav5xgwn";
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
