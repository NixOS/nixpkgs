{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdetoys-4.3.5.tar.bz2;
    sha256 = "0injni0d915zpvn22lv0vnhbfka3c4ak6kyfdnkjjxgnmgkjq1mj";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
