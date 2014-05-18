{ stdenv, fetchurl, pkgconfig, glib, libsoup, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "rest-0.7.90";

  src = fetchurl {
    url = "http://ftp.acc.umu.se/pub/GNOME/core/3.10/3.10.2/sources/${name}.tar.xz";
    sha256 = "08n0cvz44l4b1gkmjryap3ysd0wcbbbdjbcar73nr52dmk52ls0x";
  };

  buildInputs = [ pkgconfig glib libsoup gobjectIntrospection];

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
