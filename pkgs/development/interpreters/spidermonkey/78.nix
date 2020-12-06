{ stdenv
, fetchurl
, fetchpatch
, autoconf213
, pkgconfig
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
, llvmPackages
, nspr
}:

stdenv.mkDerivation rec {
  pname = "spidermonkey";
  version = "78.4.0";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "1z3hj45bnd12z3g6ajv9qrgclca7fymi1sxj9l9nh9q6y6xz0g4f";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  nativeBuildInputs = [
    autoconf213
    cargo
    llvmPackages.llvm # for llvm-objdump
    perl
    pkgconfig
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
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
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

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://developer.mozilla.org/en/SpiderMonkey";
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = with maintainers; [ abbradar lostnet ];
    platforms = platforms.linux;
  };
}
