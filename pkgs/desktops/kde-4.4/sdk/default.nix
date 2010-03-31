{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, subversion, apr, aprutil
, shared_mime_info
, kdelibs, kdepimlibs, automoc4, phonon, strigi}:

stdenv.mkDerivation {
  name = "kdesdk-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdesdk-4.4.2.tar.bz2;
    sha256 = "1cjbk35cqjif1ng8mlb5lcsilcxy9j62iviz8mzrwivdf9sixa1r";
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
