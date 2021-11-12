{ lib, stdenv
, fetchurl
, fetchpatch
, autoconf213
, pkg-config
, perl
, python3
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
, llvmPackages_12
, nspr
}:

stdenv.mkDerivation rec {
  pname = "spidermonkey";
  version = "78.11.0";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "0zjpzkxx3wc2840d7q4b9lnkj1kwk1qps29s9c83jf5y6xclnf9q";
  };

  patches = [
    # Fix build failure on armv7l using Debian patch
    # Upstream bug: https://bugzilla.mozilla.org/show_bug.cgi?id=1526653
    (fetchpatch {
      url = "https://salsa.debian.org/mozilla-team/firefox/commit/fd6847c9416f9eebde636e21d794d25d1be8791d.patch";
      sha256 = "02b7zwm6vxmk61aj79a6m32s1k5sr0hwm3q1j4v6np9jfyd10g1j";
    })
  ];

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  nativeBuildInputs = [
    autoconf213
    cargo
    llvmPackages_12.llvm # for llvm-objdump
    perl
    pkg-config
    python3
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

  configurePlatforms = [ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

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
