{ lib, stdenv, fetchurl, qt4, pkg-config, libnl, python3 }:

stdenv.mkDerivation rec {
  pname = "ntrack";
  version = "016";

  src = fetchurl {
    url = "https://launchpad.net/ntrack/main/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "037ig5y0mp327m0hh4pnfr3vmsk3wrxgfjy3645q4ws9vdhx807w";
  };

  buildInputs = [ libnl qt4 ];

  nativeBuildInputs = [ pkg-config python3 ];

  # error: ISO C does not support '__FUNCTION__' predefined identifier [-Werror=pedantic]
  NIX_CFLAGS_COMPILE = "-Wno-error";

  configureFlags = [ "--without-gobject" "CFLAGS=--std=gnu99" ];

  # Remove this patch after version 016
  patches = [ ./libnl-fix.patch ];

  postPatch = ''
    sed -e "s@/usr\(/lib/ntrack/modules/\)@$out&@" -i common/ntrack.c
  '';

  meta = with lib; {
    description = "Network Connectivity Tracking library for Desktop Applications";
    homepage = "https://launchpad.net/ntrack";
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
