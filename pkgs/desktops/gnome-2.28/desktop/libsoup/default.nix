{stdenv, fetchurl, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, 
  glib, GConf, gnome_keyring}:

stdenv.mkDerivation rec {
  name = "libsoup-2.33.6";
  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/2.33/${name}.tar.bz2";
    sha256 = "988f7897fe125a77a5946b2fd6d47d7374fd94a1406e810482cfff6a52a6a923";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl 
    glib GConf gnome_keyring ];
}
