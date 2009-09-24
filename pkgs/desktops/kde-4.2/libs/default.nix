{ stdenv, fetchurl, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, aspell, avahi
, automoc4, phonon, strigi, soprano
}:

stdenv.mkDerivation {
  name = "kdelibs-4.2.4";
  
  src = fetchurl {
    url = mirror://kde/Attic/4.2.4/src/kdelibs-4.2.4.tar.bz2;
    sha1 = "259947ede89daec94475a811a41ae7474bc4fd17";
  };
  
  includeAllQtDirs = true;

  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /* openexr */ aspell avahi
    automoc4 phonon strigi soprano
  ];
}
