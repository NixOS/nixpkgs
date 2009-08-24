{stdenv, fetchgit, pkgconfig, libxml2, gnutls, libproxy, sqlite, curl, glib, GConf
  , autoconf, automake, libtool, which
  , gnome_common, gtk_doc, gnome_keyring
  }:

stdenv.mkDerivation {
  name = "libsoup-2.27.git";
  src = fetchgit {
    url = git://git.gnome.org/libsoup;
    rev = "3d0441b3f0c402447306f53789a47abdc573f8f3";
    md5 = "22379acc77cb6a381bd0abf69ae75ca8";
  };
  buildInputs = [ pkgconfig libxml2 gnutls libproxy sqlite curl glib GConf 
    automake autoconf libtool which gnome_common gtk_doc gnome_keyring
    ];
  preConfigure = ''
    export ACLOCAL_FLAGS='-I ${pkgconfig}/share/aclocal -I ${gtk_doc}/share/aclocal -I ${libtool}/share/aclocal'
    ./autogen.sh
  '';
  configureFlags = ["--without-gnome"];
}
