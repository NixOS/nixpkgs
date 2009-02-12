{stdenv, fetchurl, cmake, qt4, xlibs, bzip2, libxml2, libxslt, perl, exiv2, aspell,
pthread_stubs, gst_all, xineLib, fam, log4cxx, cluceneCore, redland, avahi, jdk,
pcre, jasper, openexr, shared_mime_info, giflib}:

rec {
### SUPPORT
  automoc4 = import ./support/automoc4 {
    inherit stdenv fetchurl cmake;
    inherit qt4;
  };

  phonon = import ./support/phonon {
    inherit stdenv fetchurl cmake;
    inherit qt4 pthread_stubs gst_all xineLib;
    inherit (xlibs) libXau libXdmcp;
    inherit automoc4;
  };

  strigi = import ./support/strigi {
    inherit stdenv fetchurl cmake perl;
    inherit bzip2 qt4 libxml2 exiv2 fam log4cxx cluceneCore;
  };
  
  soprano = import ./support/soprano {
    inherit stdenv fetchurl cmake;
    inherit qt4 jdk cluceneCore redland;
  };
  
### LIBS
  kdelibs = import ./libs {
    inherit stdenv fetchurl cmake perl;
    inherit qt4 bzip2 pcre fam libxml2 libxslt shared_mime_info giflib jasper;
    inherit openexr aspell avahi;
    inherit automoc4 phonon strigi soprano;    
  };
}
