{ lib, stdenv, fetchurl, fetchpatch, pkgconfig, libatomic_ops, enableLargeConfig ? false
, buildPlatform, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "boehm-gc-${version}";
  version = "7.6.4";

  src = fetchurl {
    urls = [
      "http://www.hboehm.info/gc/gc_source/gc-${version}.tar.gz"
      "https://github.com/ivmai/bdwgc/releases/download/v${version}/gc-${version}.tar.gz"
    ];
    sha256 = "076dzsqqyxd3nlzs0z277vvhqjp8nv5dqi763s0m90zr6ljiyk5r";
  };

  buildInputs = [ libatomic_ops ];
  nativeBuildInputs = [ pkgconfig ];

  outputs = [ "out" "dev" "doc" ];
  separateDebugInfo = stdenv.isLinux;

  preConfigure = stdenv.lib.optionalString (stdenv.cc.libc == "musl") ''
    export NIX_CFLAGS_COMPILE+="-D_GNU_SOURCE -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR"
  '';

  patches = [ (fetchpatch {
    url = "https://raw.githubusercontent.com/gentoo/musl/85b6a600996bdd71162b357e9ba93d8559342432/dev-libs/boehm-gc/files/boehm-gc-7.6.0-sys_select.patch";
    sha256 = "1gydwlklvci30f5dpp5ccw2p2qpph5y41r55wx9idamjlq66fbb3";
  }) ];

  configureFlags =
    [ "--enable-cplusplus" ]
    ++ lib.optional enableLargeConfig "--enable-large-config"
    ++ lib.optional (stdenv.cc.libc == "musl") "--disable-static";

  doCheck = true; # not cross;

  # Don't run the native `strip' when cross-compiling.
  dontStrip = hostPlatform != buildPlatform;

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

    homepage = http://hboehm.info/gc/;

    # non-copyleft, X11-style license
    license = http://hboehm.info/gc/license.txt;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
