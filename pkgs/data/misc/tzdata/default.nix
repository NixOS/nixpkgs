{ stdenv, fetchurl }:

let version = "2012f"; in

stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "0k2qyxkifhy3a0kxfkz737sh21j5wia3wa9s0v4lf8fn8fk7vw03";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "1skl69vydrf0vl6qifwz0yvh5fhspyd31kg6sslxdhfdlslnljkl";
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
