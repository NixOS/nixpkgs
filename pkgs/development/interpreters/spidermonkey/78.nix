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
  version = "78.1.0";

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "18k47dl9hbnpqw69csxjar5dhwa7r8k7j9kvcfgmwb1iv6ba601n";
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

  patches = [
    # https://mail.gnome.org/archives/distributor-list/2020-August/msg00000.html
    (fetchpatch {
      url = "https://github.com/ptomato/mozjs/commit/b2974f8a6558d2dc4517b49ee313a9900a853285.patch";
      sha256 = "1bl5mbx7gmad6fmpc427263i1ychi2linpg69kxlr2w91r5m6ji3";
    })
    (fetchpatch {
      url = "https://github.com/ptomato/mozjs/commit/e5a2eb99f653ae03c67e536df1d55d265a0a1605.patch";
      sha256 = "0xhy63nw2byibmjc41yh6dwpg282nylganrs5aprn9pbqbcpsvif";
    })
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
    moveToOutput bin/js60-config "$dev"
    rm $out/lib/libjs_static.ajs
    ln -s $out/bin/js60 $out/bin/js
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://developer.mozilla.org/en/SpiderMonkey";
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}
