{ stdenv, fetchurl, glib, qt4, pkgconfig, libnl, pygobject, python }:

let
  version = "014";
in

stdenv.mkDerivation rec {
  name = "ntrack-${version}";

  src = fetchurl {
    url = "http://launchpad.net/ntrack/main/${version}/+download/${name}.tar.gz";
    sha256 = "1aqn3q0dj2kk0j9rf02qgbfghlykaas7q0g8wxyz7nd6zg4qhyj2";
  };

  buildInputs = [ libnl qt4 ];

  buildNativeInputs = [ pkgconfig python ];

  configureFlags = "--without-gobject CFLAGS=--std=gnu99";

  postPatch = ''
    sed -e "s@/usr\(/lib/ntrack/modules/\)@$out&@" -i common/ntrack.c
    '';
}
