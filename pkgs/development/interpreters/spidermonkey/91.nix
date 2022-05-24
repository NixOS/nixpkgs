{ lib
, stdenv
, fetchurl

# build time
, buildPackages
, cargo
, m4
, perl
, pkg-config
, python3
, rust-cbindgen
, rustc
, which
, zip

# runtime
, icu
, nspr
, readline
, zlib
}:

stdenv.mkDerivation rec {
  pname = "spidermonkey";
  version = "91.9.1";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha512 = "d432d559f2c5f4b0bc66a755db7d61585e24a727cd8d18630854b3fb8633d54baf61ed65b580345b13d52b66288aa15ca8ca5cfcde8231e88108241f0b007683";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  nativeBuildInputs = [
    cargo
    m4
    perl
    pkg-config
    python3
    rust-cbindgen
    rustc
    rustc.llvmPackages.llvm # for llvm-objdump
    which
    zip
  ];

  buildInputs = [
    icu
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
