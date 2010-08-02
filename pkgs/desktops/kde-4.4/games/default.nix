{stdenv, fetchurl, lib, cmake, qt4, perl, shared_mime_info, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdegames-4.4.5.tar.bz2;
    sha256 = "02p4ggwk1rdxljax2iry7hirh90llcbqwynccxz4n4j6q219k6d3";
  };
  buildInputs = [ cmake qt4 perl shared_mime_info kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
