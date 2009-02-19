{stdenv, fetchurl, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdetoys-4.2.0.tar.bz2;
    md5 = "3adf538297e5dca51f15186b4acd02ce";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
}
