{ lib, stdenv, fetchurl
, autoreconfHook
, enableLargeConfig ? false # doc: https://github.com/ivmai/bdwgc/blob/v8.0.6/doc/README.macros#L195
}:

stdenv.mkDerivation rec {
  pname = "boehm-gc";
  version = "8.0.6";

  src = fetchurl {
    urls = [
      "https://github.com/ivmai/bdwgc/releases/download/v${version}/gc-${version}.tar.gz"
      "https://www.hboehm.info/gc/gc_source/gc-${version}.tar.gz"
    ];
    sha256 = "3b4914abc9fa76593596773e4da671d7ed4d5390e3d46fbf2e5f155e121bea11";
  };

  outputs = [ "out" "dev" "doc" ];
  separateDebugInfo = stdenv.isLinux && stdenv.hostPlatform.libc != "musl";

  preConfigure = lib.optionalString (stdenv.hostPlatform.libc == "musl") ''
    export NIX_CFLAGS_COMPILE+=" -D_GNU_SOURCE -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR"
  '';

  # boehm-gc whitelists GCC threading models
  patches = lib.optional stdenv.hostPlatform.isMinGW ./mcfgthread.patch;

  configureFlags =
    [ "--enable-cplusplus" "--with-libatomic-ops=none" ]
    ++ lib.optional enableLargeConfig "--enable-large-config";

  nativeBuildInputs =
    lib.optional stdenv.hostPlatform.isMinGW autoreconfHook;

  doCheck = true; # not cross;

  enableParallelBuilding = true;

  meta = {
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

    homepage = "https://hboehm.info/gc/";

    # non-copyleft, X11-style license
    license = "https://hboehm.info/gc/license.txt";

    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
