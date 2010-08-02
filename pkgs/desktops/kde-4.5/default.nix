pkgs:

pkgs.recurseIntoAttrs (rec {

### SUPPORT
  automoc4 = import ./support/automoc4 {
    inherit (pkgs) stdenv fetchurl cmake qt4;
  };

  phonon = import ./support/phonon {
    inherit (pkgs) stdenv fetchurl cmake pkgconfig qt4 xineLib pulseaudio;
    inherit (pkgs.gst_all) gstreamer gstPluginsBase;
    inherit (pkgs.xlibs) libXau libXdmcp libpthreadstubs;
    inherit automoc4;
  };

  polkit_qt_1 = import ./support/polkit-qt-1 {
    inherit (pkgs) stdenv fetchurl cmake pkgconfig qt4 glib polkit;
	inherit automoc4;
  };

  strigi = import ./support/strigi {
    inherit (pkgs) stdenv fetchurl lib cmake perl;
    inherit (pkgs) bzip2 qt4 libxml2 expat exiv2 cluceneCore;
  };
  
  soprano = import ./support/soprano {
    inherit (pkgs) stdenv fetchurl cmake cluceneCore redland libiodbc qt4;
  };

  akonadi = import ./support/akonadi {
	inherit (pkgs) stdenv fetchurl cmake qt4 shared_mime_info libxslt boost
	  mysql;
	inherit automoc4 soprano;
  };

  attica = import ./support/attica {
    inherit (pkgs) stdenv fetchurl cmake qt4;
  };

  qca2 = import ./support/qca2 {
    inherit (pkgs) stdenv fetchurl which qt4;
  };

  qca2_ossl = import ./support/qca2/ossl.nix {
    inherit (pkgs) stdenv fetchurl qt4 openssl;
    inherit qca2;
  };
  
### LIBS
  kdelibs = import ./libs {
    inherit (pkgs) stdenv fetchurl lib cmake qt4 perl bzip2 pcre fam libxml2 libxslt;
    inherit (pkgs) xz flex bison giflib jasper openexr aspell avahi shared_mime_info
      kerberos acl attr shared_desktop_ontologies enchant libdbusmenu_qt;
	inherit (pkgs) docbook_xsl docbook_xml_dtd_42;
    inherit (pkgs.xlibs) libXScrnSaver;
    inherit automoc4 phonon strigi soprano qca2 attica polkit_qt_1;
  };
})
