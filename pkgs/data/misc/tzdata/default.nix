{ stdenv, fetchurl }:

let version = "2012f"; in

stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "1k165i8g23rr0z26k02x1l4immp69g6yqjrd3lwmbvj5li4mmsdg";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "1m6rg9003mkjyvpv5gg5lcia9fzhy7ndwgs68qlpbipnw5p0k2pk";
      })
    ];

  sourceRoot = ".";

  makeFlags = "TOPDIR=$(out) TZDIR=$(out)/share/zoneinfo ETCDIR=$(TMPDIR)/etc LIBDIR=$(TMPDIR)/lib MANDIR=$(TMPDIR)/man AWK=awk";

  postInstall =
    ''
      mv $out/share/zoneinfo-posix $out/share/zoneinfo/posix
      mv $out/share/zoneinfo-leaps $out/share/zoneinfo/right
    '';

  meta = {
    homepage = http://www.iana.org/time-zones;
    description = "Database of current and historical time zones";
  };
}
