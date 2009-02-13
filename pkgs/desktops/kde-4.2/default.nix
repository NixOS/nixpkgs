pkgs:

rec {
### SUPPORT
  automoc4 = import ./support/automoc4 {
    inherit (pkgs) stdenv fetchurl cmake;
    inherit (pkgs) qt4;
  };

  phonon = import ./support/phonon {
    inherit (pkgs) stdenv fetchurl cmake;
    inherit (pkgs) qt4 pthread_stubs gst_all xineLib;
    inherit (pkgs.xlibs) libXau libXdmcp;
    inherit automoc4;
  };

  strigi = import ./support/strigi {
    inherit (pkgs) stdenv fetchurl cmake perl;
    inherit (pkgs) bzip2 qt4 libxml2 exiv2 fam log4cxx cluceneCore;
  };
  
  soprano = import ./support/soprano {
    inherit (pkgs) stdenv fetchurl cmake;
    inherit (pkgs) qt4 jdk cluceneCore redland;
  };
  
### LIBS
  kdelibs = import ./libs (pkgs // {
    inherit automoc4 phonon strigi soprano;
  });
}
