{stdenv, fetchurl, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, 
  glib, GConf, gnome_keyring}:

stdenv.mkDerivation {
  name = "libsoup-2.28.2";
  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.28/libsoup-2.28.2.tar.bz2;
    sha256 = "002kxjh6dwpps4iwly1bazxlzgqhkfszqqy26mp1gy2il3lzrlcx";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl 
    glib GConf gnome_keyring ];
}
