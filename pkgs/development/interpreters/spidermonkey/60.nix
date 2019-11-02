{ stdenv, fetchurl, fetchpatch, autoconf213, pkgconfig, perl, python2, zip, buildPackages
, which, readline, zlib, icu }:

with stdenv.lib;

let
  version = "60.9.0";
in stdenv.mkDerivation {
  pname = "spidermonkey";
  inherit version;

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "0gy5x2rnnbkqmjd9sq93s3q5na9nkba68xwpizild7k6qn63qicz";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  buildInputs = [ readline zlib icu ];
  nativeBuildInputs = [ autoconf213 pkgconfig perl which python2 zip ];

  patches = [
    # Fixed in 62.0
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1415202
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mozjs60/raw/a1b605c73f382db25977cb2d4d70a3ba2ff85b92/f/Always-use-the-equivalent-year-to-determine-the-time-zone.patch";
      sha256 = "12i225qbzlyfj2disms50zrr5jy8zgn2cc4rgsg58sfgf1bn7150";
    })
  ];

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
    export PYTHON="${buildPackages.python2.interpreter}"

    # We can't build in js/src/, so create a build dir
    mkdir obj
    cd obj/
    configureScript=../js/src/configure
  '';

  configureFlags = [
    "--with-system-zlib"
    "--with-system-icu"
    "--with-intl-api"
    "--enable-readline"
    "--enable-shared-js"
    "--enable-posix-nspr-emulation"
    "--disable-jemalloc"
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

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}
