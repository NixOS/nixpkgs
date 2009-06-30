{stdenv, fetchurl, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil,
 kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdesdk-4.2.4.tar.bz2;
    sha1 = "ad5a00f5ee4ae0f627b971b7413edb0550e92db1";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder=./builder.sh;
  inherit aprutil;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion apr aprutil
                  kdelibs kdepimlibs automoc4 phonon strigi ];
}
