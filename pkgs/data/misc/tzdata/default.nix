{ stdenv, fetchurl, buildPackages }:

stdenv.mkDerivation rec {
  name = "tzdata-${version}";
  version = "2018g";

  srcs =
    [ (fetchurl {
        url = "https://data.iana.org/time-zones/releases/tzdata${version}.tar.gz";
        sha256 = "05kayi3w9pvhj6ljx1hvwd0r8mxfzn436fjmwhx53xkj919xxpq2";
      })
      (fetchurl {
        url = "https://data.iana.org/time-zones/releases/tzcode${version}.tar.gz";
        sha256 = "09y44fzcdq3c06saa8iqqa0a59cyw6ni3p31ps0j1w3hcpxz8lxa";
      })
    ];

  sourceRoot = ".";

  outputs = [ "out" "bin" "man" "dev" ];
  propagatedBuildOutputs = [];

  makeFlags = [
    "TOPDIR=$(out)"
    "TZDIR=$(out)/share/zoneinfo"
    "BINDIR=$(bin)/bin"
    "ZICDIR=$(bin)/bin"
    "ETCDIR=$(TMPDIR)/etc"
    "TZDEFAULT=$(TMPDIR)/etc"
    "LIBDIR=$(dev)/lib"
    "MANDIR=$(man)/share/man"
    "AWK=awk"
    "CFLAGS=-DHAVE_LINK=0"
    "cc=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  doCheck = false; # needs more tools

  installFlags = [ "ZIC=./zic-native" ];

  preInstall = ''
     mv zic.o zic.o.orig
     mv zic zic.orig
     make $makeFlags cc=cc AR=ar zic
     mv zic zic-native
     mv zic.o.orig zic.o
     mv zic.orig zic
  '';

  postInstall =
    ''
      rm $out/share/zoneinfo-posix
      mkdir $out/share/zoneinfo/posix
      ( cd $out/share/zoneinfo/posix; ln -s ../* .; rm posix )
      mv $out/share/zoneinfo-leaps $out/share/zoneinfo/right

      mkdir -p "$dev/include"
      cp tzfile.h "$dev/include/tzfile.h"
    '';

  setupHook = ./tzdata-setup-hook.sh;

  meta = with stdenv.lib; {
    homepage = http://www.iana.org/time-zones;
    description = "Database of current and historical time zones";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
