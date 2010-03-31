{stdenv, fetchurl, lib, cmake, qt4, perl, shared_mime_info, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdegames-4.4.2.tar.bz2;
    sha256 = "15qj5nj39fbv0643rk3jr1ygi46jw439qs7zvwqr0w35r3k6kp6w";
  };
  buildInputs = [ cmake qt4 perl shared_mime_info kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
