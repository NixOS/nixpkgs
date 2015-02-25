{ stdenv, fetchurl }:

let version = "2015a"; in

stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "0k4fy5x1813az0dwh82v5dhnvivfxxjin2szkgyfga00gn8r0965";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "06fxf9yw39wcpqifxf3lr8cn64nlwznqcyhd0cs2z1c6y88snnw8";
      })
    ];

  sourceRoot = ".";
  outputs = [ "out" "lib" ];

  makeFlags = "TOPDIR=$(out) TZDIR=$(out)/share/zoneinfo ETCDIR=$(TMPDIR)/etc LIBDIR=$(lib)/lib MANDIR=$(TMPDIR)/man AWK=awk CFLAGS=-DHAVE_LINK=0";

  postInstall =
    ''
      rm $out/share/zoneinfo-posix
      ln -s . $out/share/zoneinfo/posix
      mv $out/share/zoneinfo-leaps $out/share/zoneinfo/right

      mkdir -p "$lib/include"
      cp tzfile.h "$lib/include/tzfile.h"
    '';

  meta = {
    homepage = http://www.iana.org/time-zones;
    description = "Database of current and historical time zones";
    platforms = stdenv.lib.platforms.all;
  };
}
