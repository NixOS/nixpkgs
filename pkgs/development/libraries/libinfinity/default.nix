{ gtkWidgets ? false # build GTK widgets for libinfinity
, avahiSupport ? false # build support for Avahi in libinfinity
, stdenv, fetchurl, pkgconfig, glib, libxml2, gnutls, gsasl
, gobject-introspection
, gtk3 ? null, gtk-doc, docbook_xsl, docbook_xml_dtd_412, avahi ? null, libdaemon, libidn, gss
, libintl }:

assert avahiSupport -> avahi != null;
assert gtkWidgets -> gtk3 != null;

let
  mkFlag = flag: feature: (if flag then "--with-" else "--without-") + feature;

  self = stdenv.mkDerivation rec {
    name = "libinfinity-${version}";
    version = "0.7.1";
    src = fetchurl {
      url = "http://releases.0x539.de/libinfinity/${name}.tar.gz";
      sha256 = "1jw2fhrcbpyz99bij07iyhy9ffyqdn87vl8cb1qz897y3f2f0vk2";
    };

    outputs = [ "bin" "out" "dev" "man" "devdoc" ];

    nativeBuildInputs = [ pkgconfig gtk-doc docbook_xsl docbook_xml_dtd_412 gobject-introspection ];
    buildInputs = [ glib libxml2 gsasl libidn gss libintl libdaemon ]
      ++ stdenv.lib.optional gtkWidgets gtk3
      ++ stdenv.lib.optional avahiSupport avahi;

    propagatedBuildInputs = [ gnutls ];

    configureFlags = [
      "--enable-gtk-doc"
      "--enable-introspection"
      (mkFlag gtkWidgets "inftextgtk")
      (mkFlag gtkWidgets "infgtk")
      "--with-infinoted"
      "--with-libdaemon"
      (mkFlag avahiSupport "avahi")
    ];

    passthru = {
      infinoted = "${self.bin}/bin/infinoted-${stdenv.lib.versions.majorMinor version}";
    };

    meta = {
      homepage = http://gobby.0x539.de/;
      description = "An implementation of the Infinote protocol written in GObject-based C";
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.phreedom ];
      platforms = with stdenv.lib.platforms; linux ++ darwin;
    };
  };
in self
