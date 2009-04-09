{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil,
 kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdesdk-4.2.2.tar.bz2;
    sha1 = "ea610bc2cf3f5beb37f03ac6ff7822fca5234003";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder=./builder.sh;
  inherit aprutil;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion apr aprutil
                  kdelibs kdepimlibs automoc4 phonon strigi ];
}
