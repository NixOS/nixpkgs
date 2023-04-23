{ lib, stdenv, fetchurl, buildPackages }:

stdenv.mkDerivation rec {
  pname = "tzdata";
  version = "2023c";

  srcs = [
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzdata${version}.tar.gz";
      hash = "sha256-P1ELXRtK6bs45IWqMCp3azF/s2N722QExK33tsrdllw=";
    })
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzcode${version}.tar.gz";
      hash = "sha256-RtF/K7Ga1zKQ8DogMAYVLg+g17EeW3FGfEqCOBGyFOc=";
    })
  ];

  sourceRoot = ".";

  patches = lib.optionals stdenv.hostPlatform.isWindows [
    ./0001-Add-exe-extension-for-MS-Windows-binaries.patch
  ];

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
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    "CFLAGS+=-DHAVE_DIRECT_H"
    "CFLAGS+=-DHAVE_SETENV=0"
    "CFLAGS+=-DHAVE_SYMLINK=0"
    "CFLAGS+=-DRESERVE_STD_EXT_IDS"
  ];

  doCheck = false; # needs more tools

  installFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "zic=${buildPackages.tzdata.bin}/bin/zic"
  ];

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
