{stdenv, fetchurl, cmake, qt4, pkgconfig, perl, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeadmin-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdeadmin-4.2.0.tar.bz2;
    md5 = "2c5b33477b5679bcd9fdbc1f8017e6fb";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 pkgconfig perl kdelibs kdepimlibs automoc4 phonon ];
}
