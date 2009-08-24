{stdenv, fetchgit, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, glib, GConf}:

stdenv.mkDerivation {
  name = "libsoup-2.27.git";
  src = fetchgit {
    url = git://git.gnome.org/libsoup;
    rev = "3d0441b3f0c402447306f53789a47abdc573f8f3";
    md5 = "22379acc77cb6a381bd0abf69ae75ca8";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl glib GConf ];
}
