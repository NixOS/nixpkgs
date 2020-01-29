{ stdenv, fetchurl, qt4, pkgconfig, libnl, python }:

let
  version = "016";
in

stdenv.mkDerivation rec {
  pname = "ntrack";
  inherit version;

  src = fetchurl {
    url = "https://launchpad.net/ntrack/main/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "037ig5y0mp327m0hh4pnfr3vmsk3wrxgfjy3645q4ws9vdhx807w";
  };

  buildInputs = [ libnl qt4 ];

  nativeBuildInputs = [ pkgconfig python ];

  # error: ISO C does not support '__FUNCTION__' predefined identifier [-Werror=pedantic]
  NIX_CFLAGS_COMPILE = "-Wno-error";

  configureFlags = [ "--without-gobject" "CFLAGS=--std=gnu99" ];

  # Remove this patch after version 016
  patches = [ ./libnl-fix.patch ];

  postPatch = ''
    sed -e "s@/usr\(/lib/ntrack/modules/\)@$out&@" -i common/ntrack.c
  '';

  meta = with stdenv.lib; {
    description = "Network Connectivity Tracking library for Desktop Applications";
    homepage = https://launchpad.net/ntrack;
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
