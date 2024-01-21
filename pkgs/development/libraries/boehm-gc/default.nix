{ lib
, stdenv
, fetchurl
# doc: https://github.com/ivmai/bdwgc/blob/v8.2.2/doc/README.macros (LARGE_CONFIG)
, enableLargeConfig ? false
, enableMmap ? true
, enableStatic ? false
, nixVersions
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boehm-gc";
  version = "8.2.2";

  src = fetchurl {
    urls = [
      # "https://www.hboehm.info/gc/gc_source/gc-${finalAttrs.version}.tar.gz"
      "https://github.com/ivmai/bdwgc/releases/download/v${finalAttrs.version}/gc-${finalAttrs.version}.tar.gz"
    ];
    sha256 = "sha256-8wEHvLBi4JIKeQ//+lbZUSNIVGhZNkwjoUviZLOINqA=";
  };

  outputs = [ "out" "dev" "doc" ];
  separateDebugInfo = stdenv.isLinux && stdenv.hostPlatform.libc != "musl";

  configureFlags = [
    "--enable-cplusplus"
    "--with-libatomic-ops=none"
  ]
  ++ lib.optional enableStatic "--enable-static"
  ++ lib.optional enableMmap "--enable-mmap"
  ++ lib.optional enableLargeConfig "--enable-large-config";

  # This stanza can be dropped when a release fixes this issue:
  #   https://github.com/ivmai/bdwgc/issues/376
  # The version is checked with == instead of versionAtLeast so we
  # don't forget to disable the fix (and if the next release does
  # not fix the problem the test failure will be a reminder to
  # extend the set of versions requiring the workaround).
  makeFlags = lib.optionals (stdenv.hostPlatform.isPower64 &&
                  finalAttrs.version == "8.2.2")
    [
      # do not use /proc primitives to track dirty bits; see:
      # https://github.com/ivmai/bdwgc/issues/479#issuecomment-1279687537
      # https://github.com/ivmai/bdwgc/blob/54522af853de28f45195044dadfd795c4e5942aa/include/private/gcconfig.h#L741
      "CFLAGS_EXTRA=-DNO_SOFT_VDB"
    ];

  # `gctest` fails under emulation on aarch64-darwin
  doCheck = !(stdenv.isDarwin && stdenv.isx86_64);

  enableParallelBuilding = true;

  passthru.tests = nixVersions;

  meta = with lib; {
    homepage = "https://hboehm.info/gc/";
    description = "The Boehm-Demers-Weiser conservative garbage collector for C and C++";
    longDescription = ''
      The Boehm-Demers-Weiser conservative garbage collector can be used as a
      garbage collecting replacement for C malloc or C++ new.  It allows you
      to allocate memory basically as you normally would, without explicitly
      deallocating memory that is no longer useful.  The collector
      automatically recycles memory when it determines that it can no longer
      be otherwise accessed.

      The collector is also used by a number of programming language
      implementations that either use C as intermediate code, want to
      facilitate easier interoperation with C libraries, or just prefer the
      simple collector interface.

      Alternatively, the garbage collector may be used as a leak detector for
      C or C++ programs, though that is not its primary goal.
    '';
    # non-copyleft, X11-style license
    changelog = "https://github.com/ivmai/bdwgc/blob/v${finalAttrs.version}/ChangeLog";
    license = "https://hboehm.info/gc/license.txt";
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
})
