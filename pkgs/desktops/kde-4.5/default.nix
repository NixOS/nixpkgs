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
  
})
