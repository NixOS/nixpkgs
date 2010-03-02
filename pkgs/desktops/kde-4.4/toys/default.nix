{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.4.1";
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdetoys-4.4.1.tar.bz2;
    sha256 = "1c5rvycdmww5i141aavx1fs5zny4bz9a6yh8q8fm1pnfppvhvfa3";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
