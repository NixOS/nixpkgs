{ lib, stdenv
, fetchurl
, fetchpatch
, autoconf213
, pkg-config
, perl
, python39
, zip
, buildPackages
, which
, readline
, zlib
, icu67
, cargo
, rustc
, rust-cbindgen
, yasm
, nspr
}:

stdenv.mkDerivation rec {
  pname = "spidermonkey";
  version = "78.15.0";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "0l91cxdc5v9fps79ckb1kid4gw6v5qng1jd9zvaacwaiv628shx4";
  };

  patches = [
    # Fix build failure on armv7l using Debian patch
    # Upstream bug: https://bugzilla.mozilla.org/show_bug.cgi?id=1526653
    (fetchpatch {
      url = "https://salsa.debian.org/mozilla-team/firefox/commit/fd6847c9416f9eebde636e21d794d25d1be8791d.patch";
      sha256 = "02b7zwm6vxmk61aj79a6m32s1k5sr0hwm3q1j4v6np9jfyd10g1j";
    })

    # Remove this when updating to 79 - The patches are already applied upstream
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1318905

    # Combination of 3 changesets, modified to apply on 78:
    # - https://hg.mozilla.org/mozilla-central/rev/06d7e1b6b7e7
    # - https://hg.mozilla.org/mozilla-central/rev/ec48f15d085c
    # - https://hg.mozilla.org/mozilla-central/rev/6803dda74d33
    ./add-riscv64-support.patch
  ];

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  nativeBuildInputs = [
    autoconf213
    cargo
    rustc.llvmPackages.llvm # for llvm-objdump
    perl
    pkg-config
    python39
    rust-cbindgen
    rustc
    which
    yasm # to buid icu? seems weird
    zip
  ];

  buildInputs = [
    icu67
    nspr
    readline
    zlib
  ];

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
    export PYTHON="${buildPackages.python3.interpreter}"

    # We can't build in js/src/, so create a build dir
    mkdir obj
    cd obj/
    configureScript=../js/src/configure
  '';

  configureFlags = [
    "--with-system-zlib"
    "--with-system-nspr"
    "--with-system-icu"
    "--with-intl-api"
    "--enable-readline"
    "--enable-shared-js"
    "--disable-jemalloc"
    # Fedora and Arch disable optimize, but it doesn't seme to be necessary
    # It turns on -O3 which some gcc version had a problem with:
    # https://src.fedoraproject.org/rpms/mozjs38/c/761399aba092bcb1299bb4fccfd60f370ab4216e
    "--enable-optimize"
    "--enable-release"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # Spidermonkey seems to use different host/build terminology for cross
    # compilation here.
    "--host=${stdenv.buildPlatform.config}"
    "--target=${stdenv.hostPlatform.config}"
  ];

  # mkDerivation by default appends --build/--host to configureFlags when cross compiling
  # These defaults are bogus for Spidermonkey - avoid passing them by providing an empty list
  configurePlatforms = [ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # cc-rs insists on using -mabi=lp64 (soft-float) for riscv64,
  # while we have a double-float toolchain
  NIX_CFLAGS_COMPILE = lib.optionalString (with stdenv.hostPlatform; isRiscV && is64bit) "-mabi=lp64d";

  # Remove unnecessary static lib
  preFixup = ''
    moveToOutput bin/js78-config "$dev"
    rm $out/lib/libjs_static.ajs
    ln -s $out/bin/js78 $out/bin/js
  '';

  enableParallelBuilding = true;

  postPatch = ''
    # This patch is a manually applied fix of
    #   https://bugzilla.mozilla.org/show_bug.cgi?id=1644600
    # Once that bug is fixed, this can be removed.
    # This is needed in, for example, `zeroad`.
    substituteInPlace js/public/StructuredClone.h \
         --replace "class SharedArrayRawBufferRefs {" \
                   "class JS_PUBLIC_API SharedArrayRawBufferRefs {"
  '';

  meta = with lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://spidermonkey.dev/";
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = with maintainers; [ abbradar lostnet ];
    platforms = platforms.linux;
  };
}
