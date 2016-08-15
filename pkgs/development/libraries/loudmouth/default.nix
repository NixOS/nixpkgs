{ stdenv, fetchurl, openssl, libidn, glib, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "loudmouth-1.4.3";

  src = fetchurl {
    url = "mirror://gnome/sources/loudmouth/1.4/${name}.tar.bz2";
    sha256 = "1qr9z73i33y49pbpq6zy7q537g0iyc8sm56rjf0ylwcv01fkzacm";
  };

  patches = [
    ./glib-2.32.patch
    (fetchurl rec {
      name = "01-fix-sasl-md5-digest-uri.patch";
      url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/"
          + "${name}?h=packages/loudmouth";
      sha256 = "0y79vbklscgp8248iirllwmgk4q0wwyl3gmxz7l9frc2384xvanm";
    })
  ];

  configureFlags = "--with-ssl=openssl";

  propagatedBuildInputs = [ openssl libidn glib zlib ];

  buildInputs = [ pkgconfig ];

  meta = {
    description = "A lightweight C library for the Jabber protocol";
    platforms = stdenv.lib.platforms.linux;
  };
}
