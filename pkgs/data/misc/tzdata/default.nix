{ stdenv, fetchurl }:

let version = "2015c";

self = stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "0nin48g5dmkfgckp25bngxchn3sw3yyjss5sq7gs5xspbxgsq3w6";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "0bplibiy70dvlrhwqzkzxgmg81j6d2kklvjgi2f1g2zz1nkb3vkz";
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

