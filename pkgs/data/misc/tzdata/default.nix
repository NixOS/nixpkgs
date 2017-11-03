{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tzdata-${version}";
  version = "2017c";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "02yrrfj0p7ar885ja41ylijzbr8wc6kz6kzlw8c670i9m693ym6n";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "1dvrq0b2hz7cjqdyd7x21wpy4qcng3rvysr61ij0c2g64fyb9s41";
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
    "MANDIR=$(man)/share/man"
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
