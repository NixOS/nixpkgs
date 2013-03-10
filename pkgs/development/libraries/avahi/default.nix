{ fetchurl, stdenv, pkgconfig, libdaemon, dbus, perl, perlXMLParser
, expat, gettext, intltool, glib, qt4 ? null, libiconvOrEmpty
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
      "--disable-python"
      "--with-distro=none" "--localstatedir=/var"
    ] ++ stdenv.lib.optional withLibdnssdCompat "--enable-compat-libdns_sd";

  meta = {
    description = "Avahi, an mDNS/DNS-SD implementation";
    longDescription = ''
      Avahi is a system which facilitates service discovery on a local
      network.  It is an implementation of the mDNS (for "Multicast
      DNS") and DNS-SD (for "DNS-Based Service Discovery")
      protocols.
    '';

    homepage = http://avahi.org;
    license = "LGPLv2+";

    platforms = stdenv.lib.platforms.linux;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
