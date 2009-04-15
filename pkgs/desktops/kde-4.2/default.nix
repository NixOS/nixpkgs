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
  
  qca2 = import ./support/qca2 {
    inherit (pkgs) stdenv fetchurl which qt4;
  };
  
  akonadi = import ./support/akonadi {
    inherit (pkgs) stdenv fetchurl cmake qt4 shared_mime_info libxslt boost mysql;
    inherit automoc4;
  };
  
  decibel = import ./support/decibel {
    inherit (pkgs) stdenv fetchurl cmake qt4 tapioca_qt telepathy_qt dbus;
  };
  
  eigen = import ./support/eigen {
    inherit (pkgs) stdenv fetchurl cmake;
  };
  
### LIBS
  kdelibs = import ./libs {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl bzip2 pcre fam libxml2 libxslt;
    inherit (pkgs) giflib jasper openexr aspell avahi shared_mime_info;
    inherit automoc4 phonon strigi soprano;
  };

### BASE  
  kdebase_workspace = import ./base-workspace {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl python pam sip pyqt4;
    inherit (pkgs) lm_sensors libxklavier libusb pthread_stubs boost ConsoleKit;
    inherit (pkgs.xlibs) libXi libXau libXdmcp libXtst libXcomposite libXdamage libXScrnSaver;
    inherit kdelibs kdepimlibs kdebindings;
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

  kdepimlibs = import ./pimlibs {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl boost cyrus_sasl gpgme libical openldap;
    inherit kdelibs;
    inherit automoc4 phonon akonadi;
  };
  
  kdeadmin = import ./admin {
    inherit (pkgs) stdenv fetchurl cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer rhpl;
    inherit kdelibs kdepimlibs kdebindings;
    inherit automoc4 phonon;
  };
  
  kdeartwork = import ./artwork {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl xscreensaver;
    inherit kdelibs kdebase_workspace;
    inherit automoc4 phonon strigi eigen;
  };
  
  kdeedu = import ./edu {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl libxml2 libxslt openbabel boost;
    inherit (pkgs) readline gmm gsl facile ocaml;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
  
  kdegraphics = import ./graphics {
    inherit (pkgs) stdenv fetchurl cmake perl qt4 exiv2 lcms saneBackends libgphoto2;
    inherit (pkgs) libspectre djvulibre chmlib;
    inherit (pkgs.xlibs) libXxf86vm;
    poppler = pkgs.popplerQt4;
    inherit kdelibs;
    inherit automoc4 phonon strigi qimageblitz soprano qca2;
  };
  
  kdemultimedia = import ./multimedia {
    inherit (pkgs) stdenv fetchurl cmake perl qt4;
    inherit (pkgs) alsaLib xineLib libvorbis flac taglib cdparanoia;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
  
  kdenetwork = import ./network {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl gmp speex libxml2 libxslt sqlite alsaLib;
    inherit (pkgs) libidn libvncserver tapioca_qt libmsn;
    inherit (pkgs.xlibs) libXtst libXdamage libXxf86vm;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon qca2 soprano qimageblitz;
  };
  
  kdepim = import ./pim {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl boost gpgme libassuan libgpgerror libxslt;
    inherit (pkgs) shared_mime_info;
    inherit (pkgs.xlibs) libXScrnSaver;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon akonadi strigi soprano qca2;
  };
  
  kdeplasma_addons = import ./plasma-addons {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl python shared_mime_info;
    inherit kdelibs kdebase_workspace kdepimlibs kdegraphics;
    inherit automoc4 phonon;
  };
  
  kdegames = import ./games {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl;
    inherit kdelibs;
    inherit automoc4 phonon qca2;
  };

  kdetoys = import ./toys {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl;
    inherit kdelibs kdebase_workspace;
    inherit automoc4 phonon;
  };
    
  kdeutils = import ./utils {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl python gmp libzip libarchive sip pyqt4 pycups system_config_printer rhpl;
    inherit kdelibs kdepimlibs kdebindings;
    inherit automoc4 phonon qimageblitz;
  };
  
### DEVELOPMENT

  kdebindings = import ./bindings {
    inherit (pkgs) stdenv fetchurl python sip zlib libpng pyqt4 freetype fontconfig qt4;
    inherit (pkgs.xlibs) libSM libXrender libXrandr libXfixes libXcursor libXinerama libXext;
    inherit kdelibs;
  };
  
  kdesdk = import ./sdk {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl libxml2 libxslt boost subversion apr aprutil;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon strigi;
  };
  
  kdewebdev = import ./webdev {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl libxml2 libxslt boost;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon;
  };

#### EXTRA GEAR

  amarok = import ./extragear/amarok {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl gettext curl mysql libxml2 taglib loudmouth;
    inherit kdelibs;
    inherit automoc4 phonon strigi soprano;
  };
  
  kdesvn = import ./extragear/kdesvn {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl gettext apr aprutil subversion db4;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
  
  krusader = import ./extragear/krusader {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl gettext;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
  
  ktorrent = import ./extragear/ktorrent {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl gmp taglib boost gettext;
    inherit kdelibs kdepimlibs kdebase_workspace;
    inherit automoc4 phonon qca2;
  };
}
