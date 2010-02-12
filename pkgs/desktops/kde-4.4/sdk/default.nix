{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil
, kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdesdk-4.3.4.tar.bz2;
    sha1 = "42b6209908f8baadc0add46153649ebdfa9a977a";
  };
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
