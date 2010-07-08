{ fetchurl, stdenv, pkgconfig, libdaemon, dbus, perl, perlXMLParser
, expat, gettext, intltool, glib, gtk, qt4 ? null, lib
, qt4Support ? false }:

assert qt4Support -> qt4 != null;

stdenv.mkDerivation rec {
  name = "avahi-0.6.25";
  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0ndsrd357igp0m2cd8vwr16gmh6axlndf34hlg7qqnsiymsdj84j";
  };

  patches = [ ./no-mkdir-localstatedir.patch ];

  buildInputs = [
      pkgconfig libdaemon dbus perl perlXMLParser glib expat
      gettext intltool
    ]
    ++ (lib.optional qt4Support qt4);

  configureFlags =
    [ "--disable-qt3" "--disable-gdbm" "--disable-gtk" "--disable-mono"
      "--${if qt4Support then "enable" else "disable"}-qt4" "--disable-python"
      "--with-distro=none" "--localstatedir=/var"
    ];

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

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
