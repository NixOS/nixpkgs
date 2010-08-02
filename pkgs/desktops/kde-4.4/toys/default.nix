{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdetoys-4.4.5.tar.bz2;
    sha256 = "0cydhkgx2aqn2z0hjd7kg0da18niq89xixfhc7sq4g92xc9fryq1";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
