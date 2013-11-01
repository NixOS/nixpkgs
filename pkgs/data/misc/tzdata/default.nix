{ stdenv, fetchurl }:

let version = "2013g"; in

stdenv.mkDerivation rec {
  name = "tzdata-${version}";

  srcs =
    [ (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzdata${version}.tar.gz";
        sha256 = "0krsgncjnk64g3xshj5xd3znskcx9wwy20g1wmm2lwycincx7kdn";
      })
      (fetchurl {
        url = "http://www.iana.org/time-zones/repository/releases/tzcode${version}.tar.gz";
        sha256 = "0ysqm72xm9vcykqg9zgry69w6gr3i6b6mpbvgfmwyrdvb6s5ihy7";
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
