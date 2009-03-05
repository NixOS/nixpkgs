{stdenv, fetchurl, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdetoys-4.2.1.tar.bz2;
    sha1 = "46157a10a35d37e798faa8bb988ac1c3f2a51f07";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
}
