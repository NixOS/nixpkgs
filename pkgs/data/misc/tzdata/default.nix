{ lib, stdenv, fetchurl, buildPackages }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tzdata";
  version = "2024a";

  srcs = [
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzdata${finalAttrs.version}.tar.gz";
      hash = "sha256-DQQ0RZrL0gWaeo2h8zBKhKhlkfbtacYkj/+lArbt/+M=";
    })
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzcode${finalAttrs.version}.tar.gz";
      hash = "sha256-gAcolK3/WkWPHRQ+FuTKHYsqEiycU5naSCy2jLpqH/g=";
    })
  ];

  sourceRoot = ".";

  patches = lib.optionals stdenv.hostPlatform.isWindows [
    ./0001-Add-exe-extension-for-MS-Windows-binaries.patch
  ];

  outputs = [ "out" "bin" "man" "dev" ];
  propagatedBuildOutputs = [ ];

  makeFlags = [
    "TOPDIR=${placeholder "out"}"
    "TZDIR=${placeholder "out"}/share/zoneinfo"
    "BINDIR=${placeholder "bin"}/bin"
    "ZICDIR=${placeholder "bin"}/bin"
    "ETCDIR=$(TMPDIR)/etc"
    "TZDEFAULT=tzdefault-to-remove"
    "LIBDIR=${placeholder "dev"}/lib"
    "MANDIR=${placeholder "man"}/share/man"
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

  doCheck = true;
  # everything except for:
  # - check_web, because that needs curl and wants to talk to https://validator.w3.org
  # - check_now, because that depends on the current time
  checkTarget = "check_back check_character_set check_white_space check_links check_name_lengths check_slashed_abbrs check_sorted check_tables check_ziguard check_zishrink check_tzs";

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

      cp leap-seconds.list $out/share/zoneinfo

      mkdir -p "$dev/include"
      cp tzfile.h "$dev/include/tzfile.h"
    '';

  setupHook = ./tzdata-setup-hook.sh;

  meta = with lib; {
    homepage = "http://www.iana.org/time-zones";
    description = "Database of current and historical time zones";
    changelog = "https://github.com/eggert/tz/blob/${finalAttrs.version}/NEWS";
    license = with licenses; [
      bsd3 # tzcode
      publicDomain # tzdata
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ ajs124 fpletz ];
  };
})
