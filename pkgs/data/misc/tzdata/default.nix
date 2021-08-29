{ lib, stdenv, fetchurl, buildPackages }:

stdenv.mkDerivation rec {
  pname = "tzdata";
  version = "2020f";

  srcs =
    [ (fetchurl {
        url = "https://data.iana.org/time-zones/releases/tzdata${version}.tar.gz";
        sha256 = "10b8cr55x6ji14n3kqkn3avj1s9b79b8gszh81fxrrisij8k248j";
      })
      (fetchurl {
        url = "https://data.iana.org/time-zones/releases/tzcode${version}.tar.gz";
        sha256 = "1i998crd9fxdfhv4jd241j1arx0ng7j7cvczpmj4y5j5fwmfmvng";
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
    "CFLAGS+=-DZIC_BLOAT_DEFAULT=\\\"fat\\\""
    "cc=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  doCheck = false; # needs more tools

  installFlags = [ "ZIC=./zic-native" ];

  preInstall = ''
     mv zic.o zic.o.orig
     mv zic zic.orig
     make $makeFlags cc=${stdenv.cc.nativePrefix}cc AR=${stdenv.cc.nativePrefix}ar zic
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

  meta = with lib; {
    homepage = "http://www.iana.org/time-zones";
    description = "Database of current and historical time zones";
    changelog = "https://github.com/eggert/tz/blob/${version}/NEWS";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
