{stdenv, fetchurl, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, 
  glib, GConf, gnome_keyring}:

stdenv.mkDerivation {
  name = "libsoup-2.31.2";
  src = fetchurl {
    url = mirror://gnome/sources/libsoup/2.31/libsoup-2.31.2.tar.bz2;
    sha256 = "ae52e970deb0ca5e890d87cf55e555249c086bd56ae1fff69599174ca0075379";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl 
    glib GConf gnome_keyring ];
}
