{ stdenv, fetchurl }:

let version = "2015f"; in

stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "07ak8ai5skgjpj6lg74pawxg0bz998k7s2ah7jqyqhp086sq37wm";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "1bl4vqw6yp9199clm9aai566bmslp42g5xglj3vl24dn5fjf158c";
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
