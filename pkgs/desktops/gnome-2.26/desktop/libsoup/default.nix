{stdenv, fetchurl, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, glib, GConf}:

stdenv.mkDerivation {
  name = "libsoup-2.26.2";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/libsoup-2.26.2.tar.bz2;
    sha256 = "0ywsy30x0sl42m6s3rqk5vm4018shx1s50hsqgg9a8yybfhxvkmg";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl glib GConf ];
}
