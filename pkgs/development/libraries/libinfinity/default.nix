{ gtkWidgets ? false # build GTK widgets for libinfinity
, avahiSupport ? false # build support for Avahi in libinfinity
, stdenv, fetchurl, pkg-config, glib, libxml2, gnutls, gsasl
, gobject-introspection
, gtk3 ? null, gtk-doc, docbook_xsl, docbook_xml_dtd_412, avahi ? null, libdaemon, libidn, gss
, libintl }:

assert avahiSupport -> avahi != null;
assert gtkWidgets -> gtk3 != null;

let
  mkFlag = flag: feature: (if flag then "--with-" else "--without-") + feature;

  self = stdenv.mkDerivation rec {
    pname = "libinfinity";
    version = "0.7.2";
    src = fetchurl {
      url = "https://github.com/gobby/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
      sha256 = "17i3g61hxz9pzl3ryd1yr15142r25m06jfzjrpdy7ic1b8vjjw3f";
    };

    outputs = [ "bin" "out" "dev" "man" "devdoc" ];

    nativeBuildInputs = [ pkg-config gtk-doc docbook_xsl docbook_xml_dtd_412 gobject-introspection ];
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
      homepage = "https://gobby.github.io/";
      description = "An implementation of the Infinote protocol written in GObject-based C";
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.phreedom ];
      platforms = with stdenv.lib.platforms; linux ++ darwin;
    };
  };
in self
