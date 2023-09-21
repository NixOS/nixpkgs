{ lib, stdenv, fetchurl, fetchpatch, buildPackages }:

stdenv.mkDerivation rec {
  pname = "tzdata";
  version = "2022f";

  srcs = [
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzdata${version}.tar.gz";
      hash = "sha256-mZDXH2ddISVnuTH+iq4cq3An+J/vuKedgIppM6Z68AA=";
    })
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzcode${version}.tar.gz";
      hash = "sha256-5FQ+kPhPkfqCgJ6piTAFL9vBOIDIpiPuOk6qQvimTBU=";
    })
  ];

  sourceRoot = ".";

  patches = lib.optionals stdenv.hostPlatform.isWindows [
    ./0001-Add-exe-extension-for-MS-Windows-binaries.patch
  ] ++ [
    (fetchpatch {
      name = "fix-get-random-on-osx-1.patch";
      url = "https://github.com/eggert/tz/commit/5db8b3ba4816ccb8f4ffeb84f05b99e87d3b1be6.patch";
      hash = "sha256-FevGjiSahYwEjRUTvRY0Y6/jUO4YHiTlAAPixzEy5hw=";
    })
    (fetchpatch {
      name = "fix-get-random-on-osx-2.patch";
      url = "https://github.com/eggert/tz/commit/841183210311b1d4ffb4084bfde8fa8bdf3e6757.patch";
      hash = "sha256-1tUTZBMT7V463P7eygpFS6/k5gTeeXumk5+V4gdKpEI=";
    })
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
