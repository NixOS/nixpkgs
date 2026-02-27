{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  postgresql,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tzdata";
  version = "2025c";

  srcs = [
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzdata${finalAttrs.version}.tar.gz";
      hash = "sha256-SqeeTv/uU/xAKf/l9uvpeTcoLrzfOG1dLakc6EFC+Vc=";
    })
    (fetchurl {
      url = "https://data.iana.org/time-zones/releases/tzcode${finalAttrs.version}.tar.gz";
      hash = "sha256-aX6+ZiVESu9QgPWOSdA0JLu1Lgi/SD0921rPEMvRV0A=";
    })
  ];

  sourceRoot = ".";

  patches = lib.optionals (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isCygwin) [
    ./0001-Add-exe-extension-for-MS-Windows-binaries.patch
  ];

  outputs = [
    "out"
    "bin"
    "man"
    "dev"
  ];
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
    "CURL=:" # disable network access
    "CFLAGS=-DHAVE_LINK=0"
    "CFLAGS+=-DZIC_BLOAT_DEFAULT=\\\"fat\\\""
    "cc=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
  ++ lib.optionals stdenv.hostPlatform.isWindows [
    "CFLAGS+=-DHAVE_DIRECT_H"
    "CFLAGS+=-DHAVE_FCHMOD=0"
    "CFLAGS+=-DHAVE_GETEUID=0"
    "CFLAGS+=-DHAVE_GETRESUID=0"
    "CFLAGS+=-DHAVE_MEMPCPY=1"
    "CFLAGS+=-DHAVE_SETENV=0"
    "CFLAGS+=-DHAVE_STRUCT_STAT_ST_CTIM=0"
    "CFLAGS+=-DHAVE_SYMLINK=0"
    "CFLAGS+=-DRESERVE_STD_EXT_IDS"
    # sys/stat.h does exist on Windows for us
    "CFLAGS+=-DHAVE_SYS_STAT_H=1"
    # It is called st_ctime on windows, this forces that
    # choice
    "CFLAGS+=-DHAVE_STRUCT_STAT_ST_CTIM=0"
    "CFLAGS+=-DHAVE_MEMPCPY=1"
    "CFLAGS+=-DHAVE_GETRESUID=0"
    "CFLAGS+=-DHAVE_GETEUID=0"
    "CFLAGS+=-DHAVE_FCHMOD=0"
  ]
  ++ lib.optionals stdenv.hostPlatform.isCygwin [
    "CFLAGS+=-DHAVE_GETRESUID=0"
    "CFLAGS+=-DHAVE_ISSETUGID=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    "CFLAGS+=-DNETBSD_INSPIRED=0"
    "CFLAGS+=-DSTD_INSPIRED=0"
    "CFLAGS+=-DUSE_TIMEX_T=1"
    "CFLAGS+=-DMKTIME_FITS_IN\\(min,max\\)=0"
    "CFLAGS+=-DEXTERN_TIMEOFF=1"
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

  meta = {
    homepage = "http://www.iana.org/time-zones";
    description = "Database of current and historical time zones";
    changelog = "https://github.com/eggert/tz/blob/${finalAttrs.version}/NEWS";
    license = with lib.licenses; [
      bsd3 # tzcode
      publicDomain # tzdata
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      ajs124
      fpletz
    ];
  };
})
