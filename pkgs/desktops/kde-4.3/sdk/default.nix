{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil
, kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdesdk-4.3.5.tar.bz2;
    sha256 = "1sbzk7x1lqwp8jdzy2b6v7pw561fdrvpb4yfw4axa84f0d4cal5h";
  };
  includeAllQtDirs=true;
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
