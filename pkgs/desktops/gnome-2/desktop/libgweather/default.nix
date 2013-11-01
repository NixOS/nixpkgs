{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, GConf, libsoup, libtasn1, nettle, gmp }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libgweather-2.30.3";
  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/2.30/${name}.tar.bz2";
    sha256 = "0k16lpdyy8as8wgc5dqpy5b8i9i4mrl77qx8db23fgs2c533fddq";
  };
  configureFlags = "--with-zoneinfo-dir=${stdenv.glibc}/share/zoneinfo";
  buildInputs = [ pkgconfig libxml2 gtk intltool GConf libsoup libtasn1 nettle gmp ];
}
