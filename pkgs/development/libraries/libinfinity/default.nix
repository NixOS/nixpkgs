{ gtkWidgets ? false # build GTK widgets for libinfinity
, daemon ? false # build infinote daemon
, documentation ? false # build documentation
, avahiSupport ? false # build support for Avahi in libinfinity
, stdenv, fetchurl, pkgconfig, glib, libxml2, gnutls, gsasl
, gtk ? null, gtkdoc ? null, avahi ? null, libdaemon ? null }:

let
  edf = flag: feature: (if flag then "--with-" else "--without-") + feature;
  optional = cond: elem: assert cond -> elem != null; if cond then [elem] else [];

in stdenv.mkDerivation rec {

  name = "libinfinity-0.4.1";
  src = fetchurl {
    url = "http://releases.0x539.de/libinfinity/${name}.tar.gz";
    sha256 = "1vdyj6xvwkisrc222i84mq93gasywad4i0ismafdjq2wapxn30r6";
  };

  buildInputs = [ pkgconfig glib libxml2 gnutls gsasl ]
    ++ optional gtkWidgets gtk
    ++ optional documentation gtkdoc
    ++ optional avahiSupport avahi
    ++ optional daemon libdaemon;
  
  configureFlags = ''
    ${if documentation then "--enable-gtk-doc" else "--disable-gtk-doc"}
    ${edf gtkWidgets "inftextgtk"}
    ${edf gtkWidgets "infgtk"}
    ${edf daemon "infinoted"}
    ${edf daemon "libdaemon"}
    ${edf avahiSupport "avahi"}
  '';

  meta = {
    homepage = http://gobby.0x539.de/;
    description = "An implementation of the Infinote protocol written in GObject-based C";
    license = "LGPLv2+";
    maintainers = [ stdenv.lib.maintainers.phreedom ];
  };

}

