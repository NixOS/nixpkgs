{ gtkWidgets ? false # build GTK widgets for libinfinity
, daemon ? false # build infinote daemon
, documentation ? false # build documentation
, avahiSupport ? false # build support for Avahi in libinfinity
, stdenv, fetchurl, pkgconfig, glib, libxml2, gnutls, gsasl
, gtk ? null, gtkdoc ? null, avahi ? null, libdaemon ? null, libidn, gss }:

let
  edf = flag: feature: (if flag then "--with-" else "--without-") + feature;
  optional = cond: elem: assert cond -> elem != null; if cond then [elem] else [];

in stdenv.mkDerivation rec {

  name = "libinfinity-0.6.5";
  src = fetchurl {
    url = "http://releases.0x539.de/libinfinity/${name}.tar.gz";
    sha256 = "1idsxb6rz4i55g3vi2sv7hmm57psbccpb57yc4jgphaq6ydgqsr6";
  };

  buildInputs = [ pkgconfig glib libxml2 gsasl libidn gss ]
    ++ optional gtkWidgets gtk
    ++ optional documentation gtkdoc
    ++ optional avahiSupport avahi
    ++ optional daemon libdaemon;

  propagatedBuildInputs = [ gnutls ];
  
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
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.phreedom ];
    platforms = stdenv.lib.platforms.linux;
  };

}
