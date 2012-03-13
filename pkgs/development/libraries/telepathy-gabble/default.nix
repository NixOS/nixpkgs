{ stdenv, fetchurl, pkgconfig, libxslt, telepathy_glib, libxml2, dbus_glib
, sqlite, libsoup, libnice, gnutls }:

stdenv.mkDerivation rec {
  name = "telepathy-gabble-0.15.4";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-gabble/${name}.tar.gz";
    sha256 = "0rgqxsdcxds0ljcc01f9ifav26y80p4my37wqzkicr9hmv54h98s";
  };

  buildNativeInputs = [pkgconfig libxslt];
  buildInputs = [ libxml2 dbus_glib sqlite libsoup libnice telepathy_glib gnutls ];

  configureFlags = "--with-ca-certificates=/etc/ca-bundle.crt";
  
  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
