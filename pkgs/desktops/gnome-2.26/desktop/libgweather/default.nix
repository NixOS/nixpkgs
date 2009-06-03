{stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, GConf, libsoup}:

stdenv.mkDerivation {
  name = "libgweather-2.26.1";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/libgweather-2.26.1.tar.bz2;
    sha256 = "0hhqf4w5n3jxsl2g1a772vawlpkj4k59nikil3a6z1pcw3gygkdc";
  };
  configureFlags = "--with-zoneinfo-dir=${stdenv.glibc}/share/zoneinfo";
  buildInputs = [ pkgconfig libxml2 gtk intltool GConf libsoup ];
}
