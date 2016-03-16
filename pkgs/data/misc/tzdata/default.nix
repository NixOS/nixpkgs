{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tzdata-${version}";
  version = "2016a";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "1lccd8f8fiwfyr1f6c2ad1rgd58qlmrk5b00ywg95vv49qr6pyjy";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "13f2412ywphrvslmp1cjfyyjfrk67gbrsk4ih5n8qkl4kgandbhi";
      })
    ];

  sourceRoot = ".";
  outputs = [ "out" "lib" ];

  makeFlags = [
    "TOPDIR=$(out)"
    "TZDIR=$(out)/share/zoneinfo"
    "ETCDIR=$(TMPDIR)/etc"
    "LIBDIR=$(lib)/lib"
    "MANDIR=$(TMPDIR)/man"
    "AWK=awk"
    "CFLAGS=-DHAVE_LINK=0"
  ];

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
