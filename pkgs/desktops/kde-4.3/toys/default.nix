{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/kdetoys-4.3.2.tar.bz2;
    sha1 = "nwglmhs3nwy2j5hd8pmqndx6134b2mvm";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Games";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
