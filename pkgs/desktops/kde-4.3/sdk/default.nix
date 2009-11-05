{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil
, kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdesdk-4.3.3.tar.bz2;
    sha1 = "p8pgbiw7hca1qm4xk1a4i4jxjdijhn1v";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder=./builder.sh;
  inherit aprutil;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion apr aprutil
                  kdelibs kdepimlibs automoc4 phonon strigi ];
  meta = {
    description = "KDE SDK";
    longDescription = "Contains various development utilities such as the Umbrello UML modeler and Cerivisia CVS front-end";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
