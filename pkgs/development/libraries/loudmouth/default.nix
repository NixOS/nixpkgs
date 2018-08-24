{ stdenv, fetchurl, openssl, libidn, glib, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  version = "1.5.3";
  name = "loudmouth-${version}";

  src = fetchurl {
    url = "https://mcabber.com/files/loudmouth/${name}.tar.bz2";
    sha256 = "0b6kd5gpndl9nzis3n6hcl0ldz74bnbiypqgqa1vgb0vrcar8cjl";
  };

  patches = [
  ];

  configureFlags = [ "--with-ssl=openssl" ];

  propagatedBuildInputs = [ openssl libidn glib zlib ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "A lightweight C library for the Jabber protocol";
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "http://mcabber.com/files/loudmouth/";
    downloadURLRegexp = "loudmouth-[0-9.]+[.]tar[.]bz2$";
    updateWalker = true;
  };
}
