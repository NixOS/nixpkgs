{ stdenv, fetchurl, openssl, libidn, glib, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "loudmouth-1.4.3";

  src = fetchurl {
    url = "mirror://gnome/sources/loudmouth/1.4/${name}.tar.bz2";
    md5 = "55339ca42494690c3942ee1465a96937";
  };

  patches = [ ./glib-2.32.patch ];

  configureFlags = "--with-ssl=openssl";

  propagatedBuildInputs = [ openssl libidn glib zlib ];

  buildInputs = [ pkgconfig ];

  meta = {
    description = "A lightweight C library for the Jabber protocol";
  };
}
