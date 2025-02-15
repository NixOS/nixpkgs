{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  postgresql,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tzdata";
  version = "2025a";

  srcs = [
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzdata${finalAttrs.version}.tar.gz";
      hash = "sha256-TV/Lxyx8RQ6/4LZZvQ8cAvv1L9f1F6nqE/5xwh618NA=";
    })
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzcode${finalAttrs.version}.tar.gz";
      hash = "sha256-EZZ51Z92SB614D09KkfXhw1ZLzmZVJrxidvTHy6/UGE=";
    })
  ];

  sourceRoot = ".";

  patches = lib.optionals stdenv.hostPlatform.isWindows [
    ./0001-Add-exe-extension-for-MS-Windows-binaries.patch
  ];

  outputs = [
    "out"
    "bin"
    "man"
    "dev"
  ];
  propagatedBuildOutputs = [ ];

  makeFlags =
    [
      "TOPDIR=${placeholder "out"}"
      "TZDIR=${placeholder "out"}/share/zoneinfo"
      "BINDIR=${placeholder "bin"}/bin"
      "ZICDIR=${placeholder "bin"}/bin"
      "ETCDIR=$(TMPDIR)/etc"
      "TZDEFAULT=tzdefault-to-remove"
      "LIBDIR=${placeholder "dev"}/lib"
      "MANDIR=${placeholder "man"}/share/man"
      "AWK=awk"
      "CURL=:" # disable network access
      "CFLAGS=-DHAVE_LINK=0"
      "CFLAGS+=-DZIC_BLOAT_DEFAULT=\\\"fat\\\""
      "cc=${stdenv.cc.targetPrefix}cc"
      "AR=${stdenv.cc.targetPrefix}ar"
    ]
    ++ lib.optionals stdenv.hostPlatform.isWindows [
      "CFLAGS+=-DHAVE_DIRECT_H"
      "CFLAGS+=-DHAVE_SETENV=0"
      "CFLAGS+=-DHAVE_SYMLINK=0"
      "CFLAGS+=-DRESERVE_STD_EXT_IDS"
    ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "check";

  installFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "zic=${buildPackages.tzdata.bin}/bin/zic"
  ];

  postInstall = ''
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

  # PostgreSQL is sensitive to tzdata updates, because the test-suite often breaks.
  # Upstream provides patches very quickly, we just need to apply them until the next
  # minor releases.
  passthru.tests = postgresql;

  meta = with lib; {
    homepage = "http://www.iana.org/time-zones";
    description = "Database of current and historical time zones";
    changelog = "https://github.com/eggert/tz/blob/${finalAttrs.version}/NEWS";
    license = with licenses; [
      bsd3 # tzcode
      publicDomain # tzdata
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [
      ajs124
      fpletz
    ];
  };
})
