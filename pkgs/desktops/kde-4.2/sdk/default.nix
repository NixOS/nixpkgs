{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil,
 kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdesdk-4.2.3.tar.bz2;
    sha1 = "cf24ae63e6ee4ed875f580a7dfd8aa6d822d9b47";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder=./builder.sh;
  inherit aprutil;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion apr aprutil
                  kdelibs kdepimlibs automoc4 phonon strigi ];
}
