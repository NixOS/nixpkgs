{ lib
, stdenv
, fetchurl
, autoreconfHook
# doc: https://github.com/ivmai/bdwgc/blob/v8.2.2/doc/README.macros (LARGE_CONFIG)
, enableLargeConfig ? false
, enableMmap ? true
, nixVersions
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boehm-gc";
  version = "8.2.2";

  src = fetchurl {
    urls = [
      "https://www.hboehm.info/gc/gc_source/gc-${finalAttrs.version}.tar.gz"
      "https://github.com/ivmai/bdwgc/releases/download/v${finalAttrs.version}/gc-${finalAttrs.version}.tar.gz"
    ];
    sha256 = "sha256-8wEHvLBi4JIKeQ//+lbZUSNIVGhZNkwjoUviZLOINqA=";
  };

  outputs = [ "out" "dev" "doc" ];
  separateDebugInfo = stdenv.isLinux && stdenv.hostPlatform.libc != "musl";

  # boehm-gc whitelists GCC threading models
  patches = lib.optional stdenv.hostPlatform.isMinGW ./mcfgthread.patch;

  configureFlags = [
    "--enable-cplusplus"
    "--with-libatomic-ops=none"
  ]
  ++ lib.optional enableMmap "--enable-mmap"
  ++ lib.optional enableLargeConfig "--enable-large-config";

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isMinGW autoreconfHook;

  doCheck = true;

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
