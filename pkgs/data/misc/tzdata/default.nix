{ lib, stdenv, fetchurl, buildPackages }:

stdenv.mkDerivation rec {
  pname = "tzdata";
  version = "2022e";

  srcs = [
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzdata${version}.tar.gz";
      hash = "sha256-jeTCaG3OPRqukDBxnmgUkxwhai1eiR7D0zLm9lFq7M0=";
    })
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzcode${version}.tar.gz";
      hash = "sha256-1AKAJTmA6JFo5r5CdahSv5UhUk1HaE3jE1uaXKOHcQs=";
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
    "TZDEFAULT=tzdefault-to-remove"
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
      rm $out/share/zoneinfo/tzdefault-to-remove
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
    license = with licenses; [
      bsd3 # tzcode
      publicDomain # tzdata
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ ajs124 fpletz ];
  };
}
