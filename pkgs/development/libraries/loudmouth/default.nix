{ lib, stdenv, fetchurl, openssl, libidn, glib, pkg-config, zlib }:

stdenv.mkDerivation rec {
  version = "1.5.3";
  pname = "loudmouth";

  src = fetchurl {
    url = "https://mcabber.com/files/loudmouth/${pname}-${version}.tar.bz2";
    sha256 = "0b6kd5gpndl9nzis3n6hcl0ldz74bnbiypqgqa1vgb0vrcar8cjl";
  };

  patches = [
  ];

  configureFlags = [ "--with-ssl=openssl" ];

  propagatedBuildInputs = [ openssl libidn glib zlib ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "A lightweight C library for the Jabber protocol";
    platforms = platforms.all;
    downloadPage = "http://mcabber.com/files/loudmouth/";
    downloadURLRegexp = "loudmouth-[0-9.]+[.]tar[.]bz2$";
    updateWalker = true;
    license = licenses.lgpl21;
  };
}
