{ fetchurl, stdenv, pkgconfig, libdaemon, dbus, perl, perlXMLParser
, expat, gettext, intltool, glib, gtk, qt4 ? null, lib
, qt4Support ? false }:

assert qt4Support -> qt4 != null;

stdenv.mkDerivation rec {
  name = "avahi-0.6.24";
  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0l5rsi4s7az7cs9p4aqs77v7jrh95iiwwx0ivksmivc8c7a70016";
  };

  buildInputs = [
      pkgconfig libdaemon dbus perl perlXMLParser glib expat
      gettext intltool
    ]
    ++ lib.optional qt4Support qt4;

  configureFlags = ''
    --disable-qt3 --disable-gdbm --disable-gtk --disable-mono
    --${if qt4Support then "enable" else "disable"}-qt4
    --with-distro=none --enable-shared --disable-static --disable-python
  '';

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
  };
}
