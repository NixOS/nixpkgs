{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tzdata-${version}";
  version = "2016f";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "1c024mg4gy572vgdj9rk4dqnb33iap06zs8ibasisbyi1089b37d";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "1vb6n29ik7dzhffzzcnskbhmn6h1dxzan3zanbp118wh8hw5yckj";
      })
    ];

  sourceRoot = ".";

  outputs = [ "out" "man" "dev" ];
  propagatedBuildOutputs = [];

  makeFlags = [
    "TOPDIR=$(out)"
    "TZDIR=$(out)/share/zoneinfo"
    "ETCDIR=$(TMPDIR)/etc"
    "LIBDIR=$(dev)/lib"
    "MANDIR=$(man)/man"
    "AWK=awk"
    "CFLAGS=-DHAVE_LINK=0"
  ];

  postInstall =
    ''
      rm $out/share/zoneinfo-posix
      ln -s . $out/share/zoneinfo/posix
      mv $out/share/zoneinfo-leaps $out/share/zoneinfo/right

      mkdir -p "$dev/include"
      cp tzfile.h "$dev/include/tzfile.h"
    '';

  meta = {
    homepage = http://www.iana.org/time-zones;
    description = "Database of current and historical time zones";
    platforms = stdenv.lib.platforms.all;
  };
}
