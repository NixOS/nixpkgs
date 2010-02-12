{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdetoys-4.4.0.tar.bz2;
    sha256 = "1z9nsgvyazw29rj0g0l7sslda6k79wlb6q8a2q6fcgpzlylnpa0k";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
