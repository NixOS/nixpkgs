{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdetoys-4.3.1.tar.bz2;
    sha1 = "31a60deafef34a02fb7de5339eed1c750a456d3b";
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
