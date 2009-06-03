{stdenv, fetchurl, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdetoys-4.2.3.tar.bz2;
    sha1 = "cb84d7b8da85ed82972a4c99065644532cf12d6d";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
}
