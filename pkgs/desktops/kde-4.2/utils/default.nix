{stdenv, fetchurl, cmake, qt4, perl, gmp, python, libzip, libarchive, 
 kdelibs, kdepimlibs, automoc4, phonon, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeutils-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdeutils-4.2.0.tar.bz2;
    md5 = "f0ca24c7d3e5bb0ab55bf6b26fc6224e";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive
                  kdelibs kdepimlibs automoc4 phonon qimageblitz ];
}
