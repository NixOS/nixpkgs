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
  
  qimageblitz = import ./support/qimageblitz {
    inherit (pkgs) stdenv fetchurl cmake qt4;
  };
  
### LIBS
  kdelibs = import ./libs {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl bzip2 pcre fam libxml2 libxslt;
    inherit (pkgs) giflib jasper openexr aspell avahi shared_mime_info;
    inherit automoc4 phonon strigi soprano;
  };

### BASE  
  kdebase_workspace = import ./base-workspace {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl python;
    inherit (pkgs) lm_sensors libxklavier libusb pthread_stubs;
    inherit (pkgs.xlibs) libXi libXau libXdmcp libXtst libXcomposite libXdamage;
    inherit kdelibs;
    inherit automoc4 phonon strigi soprano qimageblitz;
  };
  
  kdebase = import ./base {
    inherit (pkgs) stdenv fetchurl cmake perl qt4 pciutils libraw1394;
    inherit kdelibs;
    inherit automoc4 phonon strigi qimageblitz soprano;
  };
  
  kdebase_runtime = import ./base-runtime {
    inherit (pkgs) stdenv fetchurl cmake perl bzip2 qt4;
    inherit (pkgs) xineLib alsaLib samba cluceneCore;
    inherit kdelibs;
    inherit automoc4 phonon strigi soprano;
  };

### ADDITIONAL

  kdegraphics = import ./graphics {
    inherit (pkgs) stdenv fetchurl cmake;
    inherit kdelibs;
  };
}
