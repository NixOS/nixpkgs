{stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, GConf, libsoup}:

stdenv.mkDerivation {
  name = "libgweather-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/libgweather/2.28/libgweather-2.28.0.tar.bz2;
    sha256 = "0m4ncqzf13037zvyihydif1asgp6pnzdkmx5qnmffzb1gd6qxzb5";
  };
  configureFlags = "--with-zoneinfo-dir=${stdenv.glibc}/share/zoneinfo";
  buildInputs = [ pkgconfig libxml2 gtk intltool GConf libsoup ];
}
