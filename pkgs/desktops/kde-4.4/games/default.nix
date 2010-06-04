{stdenv, fetchurl, lib, cmake, qt4, perl, shared_mime_info, kdelibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "kdegames-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdegames-4.4.4.tar.bz2;
    sha256 = "0zs7r9bc7az6px1745jkrqzsgv6lmhvn1rdsw3jpzcb8qk8qk5wv";
  };
  buildInputs = [ cmake qt4 perl shared_mime_info kdelibs automoc4 phonon qca2 ];
  meta = {
    description = "KDE Games";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
