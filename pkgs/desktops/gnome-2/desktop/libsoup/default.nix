{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl
, glib, GConf, libgnome_keyring }:

stdenv.mkDerivation rec {
  name = "libsoup-2.34.3";

  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.34/libsoup-2.34.3.tar.xz;
    sha256 = "072af1iqcky5vm6akm450qhdjrgav4yyl6s8idhnq0gpm5jqhgy4";
  };

  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl 
    glib GConf libgnome_keyring ];

  configureFlags = "--disable-tls-check";
}
