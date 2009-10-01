pkgs:

rec {
  inherit (pkgs) qt4;

### SUPPORT
  automoc4 = import ./support/automoc4 {
    inherit (pkgs) stdenv fetchurl lib cmake;
    inherit (pkgs) qt4;
  };

  phonon = import ./support/phonon {
    inherit (pkgs) stdenv fetchurl lib cmake;
    inherit (pkgs) qt4 pthread_stubs gst_all xineLib;
    inherit (pkgs.xlibs) libXau libXdmcp;
    inherit automoc4;
  };

  strigi = import ./support/strigi {
    inherit (pkgs) stdenv fetchurl lib cmake perl;
    inherit (pkgs) bzip2 qt4 libxml2 expat exiv2 cluceneCore;
  };
  
  soprano = import ./support/soprano {
    inherit (pkgs) stdenv fetchurl lib cmake;
    inherit (pkgs) qt4 cluceneCore;
    redland = pkgs.redland_1_0_8;
  };
  
  qimageblitz = import ./support/qimageblitz {
    inherit (pkgs) stdenv fetchurl lib cmake qt4;
  };
  
  qca2 = import ./support/qca2 {
    inherit (pkgs) stdenv fetchurl lib which qt4;
  };
  
  akonadi = import ./support/akonadi {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 shared_mime_info libxslt boost mysql;
    inherit automoc4 soprano;
  };
  
  decibel = import ./support/decibel {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 tapioca_qt telepathy_qt;
  };
  
  eigen = import ./support/eigen {
    inherit (pkgs) stdenv fetchurl lib cmake;
  };
  
  polkit_qt = import ./support/polkit-qt {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 policykit;
    inherit automoc4;
  };
  
### LIBS
  kdelibs = import ./libs {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl bzip2 pcre fam libxml2 libxslt;
    inherit (pkgs) xz flex bison giflib jasper openexr aspell avahi shared_mime_info;
    inherit automoc4 phonon strigi soprano;
  };

  kdelibs_experimental = import ./libs-experimental {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl;
    inherit automoc4 kdelibs phonon;
  };
  
### BASE  
  kdebase_workspace = import ./base-workspace {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl python pam sip pyqt4;
    inherit (pkgs) lm_sensors libxklavier libusb pthread_stubs boost ConsoleKit;
    inherit (pkgs.xlibs) libXi libXau libXdmcp libXtst libXcomposite libXdamage libXScrnSaver;
    inherit kdelibs kdelibs_experimental kdepimlibs kdebindings;
    inherit automoc4 phonon strigi soprano qimageblitz akonadi polkit_qt;
  };
  
  kdebase = import ./base {
    inherit (pkgs) stdenv fetchurl lib cmake perl qt4 pciutils libraw1394;
    inherit kdelibs kdebase_workspace;
    inherit automoc4 phonon strigi qimageblitz soprano;
  };
  
  kdebase_runtime = import ./base-runtime {
    inherit (pkgs) stdenv fetchurl lib cmake perl bzip2 xz qt4;
    inherit (pkgs) shared_mime_info xineLib alsaLib samba cluceneCore;
    inherit kdelibs;
    inherit automoc4 phonon strigi soprano;
  };

  oxygen_icons = import ./oxygen-icons {
    inherit (pkgs) stdenv fetchurl lib cmake;
  };
  
### ADDITIONAL

  kdepimlibs = import ./pimlibs {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl boost cyrus_sasl gpgme;
    inherit (pkgs) libical openldap shared_mime_info;
    inherit kdelibs;
    inherit automoc4 phonon akonadi;
  };
  
  kdeadmin = import ./admin {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 pkgconfig perl python sip pyqt4 pycups system_config_printer rhpl;
    inherit kdelibs kdepimlibs kdebindings;
    inherit automoc4 phonon;
  };
  
  kdeartwork = import ./artwork {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl xscreensaver;
    inherit kdelibs kdebase_workspace;
    inherit automoc4 phonon strigi eigen;
  };
  
  kdeedu = import ./edu {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl libxml2 libxslt openbabel boost;
    inherit (pkgs) readline gmm gsl facile ocaml xplanet;
    inherit kdelibs;
    inherit automoc4 phonon eigen;
  };
  
  kdegraphics = import ./graphics {
    inherit (pkgs) stdenv fetchurl lib cmake perl qt4 exiv2 lcms saneBackends libgphoto2;
    inherit (pkgs) libspectre djvulibre chmlib shared_mime_info;
    inherit (pkgs.xlibs) libXxf86vm;
    poppler = pkgs.popplerQt4;
    inherit kdelibs;
    inherit automoc4 phonon strigi qimageblitz soprano qca2;
  };
  
  kdemultimedia = import ./multimedia {
    inherit (pkgs) stdenv fetchurl lib cmake perl qt4;
    inherit (pkgs) alsaLib xineLib libvorbis flac taglib cdparanoia lame;
    inherit kdelibs kdelibs_experimental;
    inherit automoc4 phonon;
  };
  
  kdenetwork = import ./network {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl gmp speex libxml2 libxslt sqlite alsaLib;
    inherit (pkgs) libidn libvncserver tapioca_qt libmsn;
    inherit (pkgs.xlibs) libXtst libXdamage libXxf86vm;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon qca2 soprano qimageblitz strigi;
  };
  
  kdepim = import ./pim {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl boost gpgme libassuan libgpgerror libxslt;
    inherit (pkgs) shared_mime_info;
    inherit (pkgs.xlibs) libXScrnSaver;
    inherit kdelibs kdelibs_experimental kdepimlibs;
    inherit automoc4 phonon akonadi strigi soprano qca2;
  };
  
  kdepim_runtime = import ./pim-runtime {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl;
    inherit kdelibs kdelibs_experimental kdepimlibs;
    inherit automoc4 phonon;
  };
  
  kdeplasma_addons = import ./plasma-addons {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl python shared_mime_info;
    inherit kdelibs kdebase_workspace kdepimlibs kdebase kdegraphics kdeedu;
    inherit automoc4 phonon soprano eigen qimageblitz;
  };
  
  kdegames = import ./games {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl;
    inherit kdelibs;
    inherit automoc4 phonon qca2;
  };

  kdetoys = import ./toys {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl;
    inherit kdelibs kdebase_workspace;
    inherit automoc4 phonon;
  };
    
  kdeutils = import ./utils {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl python gmp libzip libarchive xz sip pyqt4 pycups system_config_printer rhpl;
    inherit kdelibs kdelibs_experimental kdepimlibs kdebase kdebindings;
    inherit automoc4 phonon qimageblitz qca2;
  };
  
### DEVELOPMENT

  kdebindings = import ./bindings {
    inherit (pkgs) stdenv fetchurl lib python sip zlib libpng pyqt4 freetype fontconfig qt4;
    inherit (pkgs.xlibs) libSM libXrender libXrandr libXfixes libXcursor libXinerama libXext;
    inherit kdelibs;
  };
  
  kdesdk = import ./sdk {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl libxml2 libxslt boost subversion apr aprutil;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon strigi;
  };
  
  kdewebdev = import ./webdev {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl libxml2 libxslt boost;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon;
  };

#### EXTRA GEAR

  amarok = import ./extragear/amarok {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 qtscriptgenerator perl gettext;
    inherit (pkgs) curl mysql libxml2 taglib taglib_extras loudmouth;
    inherit kdelibs;
    inherit automoc4 phonon strigi soprano;
  };
  
  kdesvn = import ./extragear/kdesvn {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl gettext apr aprutil subversion db4;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
  
  kmplayer = import ./extragear/kmplayer {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl gettext dbus_glib;
    inherit (pkgs.gtkLibs) pango gtk;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
  
  krusader = import ./extragear/krusader {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl gettext;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
  
  koffice = import ./extragear/koffice {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl lcms exiv2 libxml2 libxslt boost glew;
    inherit (pkgs) shared_mime_info gsl gmm wv2 libwpd;
    inherit kdelibs kdepimlibs;
    inherit automoc4 phonon qimageblitz qca2 eigen;
    poppler = pkgs.popplerQt4;
  };
  
  ktorrent = import ./extragear/ktorrent {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl gmp taglib boost gettext;
    inherit kdelibs kdepimlibs kdebase_workspace;
    inherit automoc4 phonon qca2;
  };
  
  gtk_qt_engine = import ./extragear/gtk-qt-engine {
    inherit (pkgs) stdenv fetchurl cmake qt4 perl gettext;
    inherit (pkgs.xlibs) libX11;
    inherit (pkgs.gtkLibs) gtk;
    inherit (pkgs.gnome) libbonoboui;
    inherit kdelibs;
    inherit automoc4 phonon;
  };
}
