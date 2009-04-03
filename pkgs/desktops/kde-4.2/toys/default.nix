{stdenv, fetchurl, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdetoys-4.2.2.tar.bz2;
    sha1 = "5057ae39c77be8792fb1c23fd8cf1e3ac06942cf";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
}
