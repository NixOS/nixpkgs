{stdenv, fetchurl, cmake, qt4, pkgconfig, perl, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdeadmin-4.2.1.tar.bz2;
    sha1 = "888203103fe86010461b1e38d51ba9a20f3250e8";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 pkgconfig perl kdelibs kdepimlibs automoc4 phonon ];
}
