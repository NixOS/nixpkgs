{ stdenv, fetchurl, glib, qt4, pkgconfig, libnl, python }:

let
  version = "016";
in

stdenv.mkDerivation rec {
  name = "ntrack-${version}";

  src = fetchurl {
    url = "http://launchpad.net/ntrack/main/${version}/+download/${name}.tar.gz";
    sha256 = "037ig5y0mp327m0hh4pnfr3vmsk3wrxgfjy3645q4ws9vdhx807w";
  };

  buildInputs = [ libnl qt4 ];

  nativeBuildInputs = [ pkgconfig python ];

  configureFlags = "--without-gobject CFLAGS=--std=gnu99";

  # Remove this patch after version 016
  patches = [ ./libnl-fix.patch ];

  postPatch = ''
    sed -e "s@/usr\(/lib/ntrack/modules/\)@$out&@" -i common/ntrack.c
  '';

  meta = {
    description = "Network Connectivity Tracking library for Desktop Applications";
    homepage = https://launchpad.net/ntrack;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
