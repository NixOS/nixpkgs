{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil
, shared_mime_info
, kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdesdk-4.4.3.tar.bz2;
    sha256 = "01wqyixni9sb4330b1cvaysaf7jsvmy9ijjryv8ixnaam3gkxzs7";
  };
  builder=./builder.sh;
  inherit aprutil;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost subversion apr aprutil shared_mime_info
                  kdelibs kdepimlibs automoc4 phonon strigi ];
  meta = {
    description = "KDE SDK";
    longDescription = "Contains various development utilities such as the Umbrello UML modeler and Cerivisia CVS front-end";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
