{ lib, stdenv, fetchurl, fetchpatch, autoconf213, pkg-config, perl, python2, python3, zip, buildPackages
, which, readline, zlib, icu, cargo, rustc, llvmPackages }:

with lib;

let
  python3Env = buildPackages.python3.withPackages (p: [p.six]);
in stdenv.mkDerivation rec {
  pname = "spidermonkey";
  version = "68.12.0";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "1k17pi4zh9hrvkzbw4rzzw879a15hpvwriylp75wl22rl7r2nsdf";
  };

  patches = [
    # Backport a change from Firefox 75 that fixes finding the
    # location of clang and libclang.
    (fetchpatch {
      url = "https://hg.mozilla.org/mozilla-central/raw-rev/ccd1356fc8f1d0bfa9d896e88d3cc924425623da";
      sha256 = "005g3mfmal9nw32khrgyiv3221z7pazfhhm2qvgc8d48i2yzj3j0";
    })
  ];

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  nativeBuildInputs = [
    autoconf213
    pkg-config
    perl
    which
    python2
    zip
    cargo
    rustc
    llvmPackages.llvm
  ];

  buildInputs = [
    readline
    zlib
    icu
  ];

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
    export PYTHON3="${python3Env.interpreter}"

    # We can't build in js/src/, so create a build dir
    mkdir obj
    cd obj/
    configureScript=../js/src/configure
  '';

  configureFlags = [
    # Reccommended by gjs upstream
    "--disable-jemalloc"
    "--enable-unaligned-private-values"
    "--with-intl-api"
    "--enable-posix-nspr-emulation"
    "--with-system-zlib"
    "--with-system-icu"

    "--enable-shared-js"
    "--enable-readline"
    # Fedora and Arch disable optimize, but it doesn't seme to be necessary
    # It turns on -O3 which some gcc version had a problem with:
    # https://src.fedoraproject.org/rpms/mozjs38/c/761399aba092bcb1299bb4fccfd60f370ab4216e
    "--enable-optimize"
    "--enable-release"
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # Spidermonkey seems to use different host/build terminology for cross
    # compilation here.
    "--host=${stdenv.buildPlatform.config}"
    "--target=${stdenv.hostPlatform.config}"
  ];

  configurePlatforms = [];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # Remove unnecessary static lib
  preFixup = ''
    moveToOutput bin/js60-config "$dev"
    rm $out/lib/libjs_static.ajs
    ln -s $out/bin/js60 $out/bin/js
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://developer.mozilla.org/en/SpiderMonkey";
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.abbradar ];
    badPlatforms = [ "riscv32-linux" "riscv64-linux" ];
    platforms = platforms.linux;
  };
}
