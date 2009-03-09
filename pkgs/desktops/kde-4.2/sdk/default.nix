{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr,
 kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdesdk-4.2.1.tar.bz2;
    sha1 = "dca74527bcf6e5925ec58a74196e683cc68a259a";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion apr
                  kdelibs kdepimlibs automoc4 phonon strigi ];
}
