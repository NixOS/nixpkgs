{ lib, stdenv
, fetchurl
, pkg-config
, perl
, python3
, zip
, buildPackages
, which
, readline
, zlib
, icu69
, cargo
, rustc
, rust-cbindgen
, yasm
, nspr
, m4
}:

stdenv.mkDerivation rec {
  pname = "spidermonkey";
  version = "91.8.0";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha512 = "edea2c7d4d3d0322091b20b623019ef041090d9f89f33c8e3140f66a54624261f278257393db70d2038154de8ee02da0bee6ecf85c281f3558338da71fc173c3";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  nativeBuildInputs = [
    cargo
    rustc.llvmPackages.llvm # for llvm-objdump
    perl
    pkg-config
    python3
    rust-cbindgen
    rustc
    which
    yasm # to buid icu? seems weird
    zip
    m4
  ];

  buildInputs = [
    icu69
    nspr
    readline
    zlib
  ];

  preConfigure = ''
    export LIBXUL_DIST=$out
    export PYTHON="${buildPackages.python3.interpreter}"
    export M4=m4
    export AWK=awk
    export AC_MACRODIR=$PWD/build/autoconf/

    pushd js/src
    sh ../../build/autoconf/autoconf.sh --localdir=$PWD configure.in > configure
    chmod +x configure
    popd
    # We can't build in js/src/, so create a build dir
    mkdir obj
    cd obj/
    configureScript=../js/src/configure
  '';

  configureFlags = [
    "--with-intl-api"
    "--with-system-icu"
    "--with-system-nspr"
    "--with-system-zlib"
    "--enable-optimize"
    "--enable-readline"
    "--enable-release"
    "--enable-shared-js"
    "--disable-debug"
    "--disable-jemalloc"
    "--disable-strip"
    "--disable-tests"
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

  # Remove unnecessary static lib
  preFixup = ''
    moveToOutput bin/js91-config "$dev"
    rm $out/lib/libjs_static.ajs
    ln -s $out/bin/js91 $out/bin/js
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
    license = licenses.mpl20;
    maintainers = with maintainers; [ lostnet ];
    platforms = platforms.linux;
  };
}
