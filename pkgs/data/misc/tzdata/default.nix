{ stdenv, fetchurl }:

let version = "2015g";

self = stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "0qb1awqrn3215zd2jikpqnmkzrxwfjf0d3dw2xmnk4c40yzws8xr";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "1i3y1kzjiz2j62c7vd4wf85983sqk9x9lg3473njvbdz4kph5r0q";
      })
    ];

  sourceRoot = ".";
  #outputs = [ "out" "lib" ]; # TODO: maybe resurrect, and maybe install man pages?

  makeFlags = "TOPDIR=$(out) TZDIR=$(out)/share/zoneinfo ETCDIR=$(TMPDIR)/etc LIBDIR=$(out)/lib MANDIR=$(TMPDIR)/man AWK=awk CFLAGS=-DHAVE_LINK=0";

  postInstall =
    ''
      rm $out/share/zoneinfo-posix
      ln -s . $out/share/zoneinfo/posix
      mv $out/share/zoneinfo-leaps $out/share/zoneinfo/right

      mkdir -p "$out/include"
      cp tzfile.h "$out/include/tzfile.h"
    '';

  meta = {
    homepage = http://www.iana.org/time-zones;
    description = "Database of current and historical time zones";
    platforms = stdenv.lib.platforms.all;
  };
}

;in self // { lib = self; }

