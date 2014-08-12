{ stdenv, fetchurl }:

let version = "2014e"; in

stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "1ic63ykplnrvh9704j6l089rais0nxw1lcf1dbc3iy2ij2kl7qh8";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "074c98vmdgysgkksaqwkn1gbrlnzk8l28zs8lhif44a9mckc9ss3";
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
  };
}
