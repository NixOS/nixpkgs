{stdenv, fetchurl, lib, cmake, qt4, perl, shared_mime_info, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdegames-4.4.3.tar.bz2;
    sha256 = "0i14zd0jxbgrvxgpwq80ghfbhcj9awq1rh7g5716j514wl25nqpl";
  };
  buildInputs = [ cmake qt4 perl shared_mime_info kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
