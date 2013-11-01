{ fetchurl, stdenv, pkgconfig, libdaemon, dbus, perl, perlXMLParser
, expat, gettext, intltool, glib, libiconvOrEmpty
, qt4 ? null
, qt4Support ? false
, withLibdnssdCompat ? false }:

assert qt4Support -> qt4 != null;

stdenv.mkDerivation rec {
  name = "avahi-0.6.30";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "07zzaxs81rbrfhj0rnq616c3j37f3g84dn7d4q3h5l1r4dn33r7r";
  };

  patches = [ ./no-mkdir-localstatedir.patch ];

  buildInputs = [ libdaemon dbus perl perlXMLParser glib expat ]
    ++ (stdenv.lib.optional qt4Support qt4)
    ++ libiconvOrEmpty;

  nativeBuildInputs = [ pkgconfig gettext intltool ];

  configureFlags =
    [ "--disable-qt3" "--disable-gdbm" "--disable-mono"
      "--disable-gtk" "--disable-gtk3"
      "--${if qt4Support then "enable" else "disable"}-qt4"
      "--disable-python" "--localstatedir=/var" "--with-distro=none" ]
    ++ stdenv.lib.optional withLibdnssdCompat "--enable-compat-libdns_sd"
    # autoipd won't build on darwin
    ++ stdenv.lib.optional stdenv.isDarwin "--disable-autoipd";

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i '20 i\
    #define __APPLE_USE_RFC_2292' \
    avahi-core/socket.c
  '';

  meta = with stdenv.lib; {
    description = "mDNS/DNS-SD implementation";
    homepage    = http://avahi.org;
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ lovek323 ];

    longDescription = ''
      Avahi is a system which facilitates service discovery on a local
      network.  It is an implementation of the mDNS (for "Multicast
      DNS") and DNS-SD (for "DNS-Based Service Discovery")
      protocols.
    '';
  };
}
