{ stdenv, fetchurl, openssl, libidn, glib, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "loudmouth-1.4.3";

  src = fetchurl {
    url = "mirror://gnome/sources/loudmouth/1.4/${name}.tar.bz2";
    sha256 = "1qr9z73i33y49pbpq6zy7q537g0iyc8sm56rjf0ylwcv01fkzacm";
  };

  patches = [ ./glib-2.32.patch ];

  configureFlags = "--with-ssl=openssl";

  propagatedBuildInputs = [ openssl libidn glib zlib ];

  buildInputs = [ pkgconfig ];

  meta = {
    description = "A lightweight C library for the Jabber protocol";
  };
}
