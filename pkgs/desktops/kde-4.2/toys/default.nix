{stdenv, fetchurl, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdetoys-4.2.4.tar.bz2;
    sha1 = "3f05154f85d0a01ceb97854e31adff03a7b5fdda";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
}
