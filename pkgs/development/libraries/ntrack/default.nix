{ stdenv, fetchurl, glib, qt4, pkgconfig, libnl2, pygobject, python }:

let
  version = "011";
in

stdenv.mkDerivation rec {
  name = "ntrack-${version}";

  src = fetchurl {
    url = "http://launchpad.net/ntrack/main/${version}/+download/${name}.tar.gz";
    sha256 = "0qi6nhymsv7w6hfxnz9jbxk311wb6x9jci7a3gcr4cc5nwkl7sxy";
  };

  buildInputs = [ libnl2 qt4 ];

  buildNativeInputs = [ pkgconfig python ];

  configureFlags = "--without-gobject CFLAGS=--std=gnu99";

  patches = [ ./libnl2.patch ];
  postPatch = ''
    sed -e "s@/usr\(/lib/ntrack/modules/\)@$out&@" -i common/ntrack.c
    '';
}
