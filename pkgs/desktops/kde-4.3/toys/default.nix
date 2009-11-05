{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdetoys-4.3.3.tar.bz2;
    sha1 = "jqva7p33yzsi5ij3b1fq1yqxkcbikp39";
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
