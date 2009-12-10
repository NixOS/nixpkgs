{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdetoys-4.3.4.tar.bz2;
    sha1 = "96f6121990590acd3fb5b8cae25ef98b5572733c";
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
