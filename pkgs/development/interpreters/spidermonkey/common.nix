{ version, hash }:

{ callPackage
, lib
, stdenv
, fetchurl
, fetchpatch

# build time
, buildPackages
, cargo
, m4
, perl
, pkg-config
, python3
, python39
, rustc
, which
, zip
, autoconf213
, yasm
, xcbuild

# runtime
, icu
, icu67
, nspr
, readline
, zlib
, libobjc
, libiconv
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "spidermonkey";
  inherit version;

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    inherit hash;
  };

  patches = lib.optional (lib.versionOlder version "91") [
    # Fix build failure on armv7l using Debian patch
    # Upstream bug: https://bugzilla.mozilla.org/show_bug.cgi?id=1526653
    (fetchpatch {
      url = "https://salsa.debian.org/mozilla-team/firefox/commit/fd6847c9416f9eebde636e21d794d25d1be8791d.patch";
      hash = "sha512-K8U3Qyo7g4si2r/8kJdXyRoTrDHAY48x/YJ7YL+YBwlpfNQcHxX+EZvhRzW8FHYW+f7kOnJu9QykhE8PhSQ9zQ==";
    })

    # Remove this when updating to 79 - The patches are already applied upstream
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1318905

    # Combination of 3 changesets, modified to apply on 78:
    # - https://hg.mozilla.org/mozilla-central/rev/06d7e1b6b7e7
    # - https://hg.mozilla.org/mozilla-central/rev/ec48f15d085c
    # - https://hg.mozilla.org/mozilla-central/rev/6803dda74d33
    ./add-riscv64-support.patch
  ] ++ lib.optionals (lib.versionAtLeast version "102") [
    # use pkg-config at all systems
    ./always-check-for-pkg-config.patch
    ./allow-system-s-nspr-and-icu-on-bootstrapped-sysroot.patch

    # Patches required by GJS
    # https://discourse.gnome.org/t/gnome-43-to-depend-on-spidermonkey-102/10658
    # Install ProfilingCategoryList.h
    (fetchpatch {
      url = "https://hg.mozilla.org/releases/mozilla-esr102/raw-rev/33147b91e42b79f4c6dd3ec11cce96746018407a";
      sha256 = "sha256-xJFJZMYJ6P11HQDZbr48GFgybpAeVcu3oLIFEyyMjBI=";
    })
    # Fix embeder build
    (fetchpatch {
      url = "https://hg.mozilla.org/releases/mozilla-esr102/raw-rev/1fa20fb474f5d149cc32d98df169dee5e6e6861b";
      sha256 = "sha256-eCisKjNxy9SLr9KoEE2UB26BflUknnR7PIvnpezsZeA=";
    })
  ];

  nativeBuildInputs = [
    cargo
    m4
    perl
    pkg-config
    # 78 requires python up to 3.9
    (if lib.versionOlder version "91" then python39 else python3)
    rustc
    rustc.llvmPackages.llvm # for llvm-objdump
    which
    zip
  ] ++ lib.optionals (lib.versionOlder version "91") [
    autoconf213
    yasm # to buid icu? seems weird
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
  ];

  buildInputs = [
    (if lib.versionOlder version "91" then icu67 else icu)
    nspr
    readline
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
    libiconv
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  setOutputFlags = false; # Configure script only understands --includedir

  configureFlags = [
    "--with-intl-api"
    "--with-system-icu"
    "--with-system-nspr"
    "--with-system-zlib"
    # Fedora and Arch disable optimize, but it doesn't seme to be necessary
    # It turns on -O3 which some gcc version had a problem with:
    # https://src.fedoraproject.org/rpms/mozjs38/c/761399aba092bcb1299bb4fccfd60f370ab4216e
    "--enable-optimize"
    "--enable-readline"
    "--enable-release"
    "--enable-shared-js"
  ] ++ lib.optionals (lib.versionAtLeast version "91") [
    "--disable-debug"
  ] ++ [
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

  enableParallelBuilding = true;

  # cc-rs insists on using -mabi=lp64 (soft-float) for riscv64,
  # while we have a double-float toolchain
  NIX_CFLAGS_COMPILE = lib.optionalString (with stdenv.hostPlatform; isRiscV && is64bit && lib.versionOlder version "91") "-mabi=lp64d";

  postPatch = lib.optionalString (lib.versionOlder version "102") ''
    # This patch is a manually applied fix of
    #   https://bugzilla.mozilla.org/show_bug.cgi?id=1644600
    # Once that bug is fixed, this can be removed.
    # This is needed in, for example, `zeroad`.
    substituteInPlace js/public/StructuredClone.h \
         --replace "class SharedArrayRawBufferRefs {" \
                   "class JS_PUBLIC_API SharedArrayRawBufferRefs {"
  '';

  preConfigure = lib.optionalString (lib.versionOlder version "91") ''
    export CXXFLAGS="-fpermissive"
  '' + ''
    export LIBXUL_DIST=$out
    export PYTHON="${buildPackages.python3.interpreter}"
  '' + lib.optionalString (lib.versionAtLeast version "91") ''
    export M4=m4
    export AWK=awk
    export AS=$CC
    export AC_MACRODIR=$PWD/build/autoconf/

    pushd js/src
    sh ../../build/autoconf/autoconf.sh --localdir=$PWD configure.in > configure
    chmod +x configure
    popd
  '' + ''
    # We can't build in js/src/, so create a build dir
    mkdir obj
    cd obj/
    configureScript=../js/src/configure
  '';

  # Remove unnecessary static lib
  preFixup = ''
    moveToOutput bin/js${lib.versions.major version}-config "$dev"
    rm $out/lib/libjs_static.ajs
    ln -s $out/bin/js${lib.versions.major version} $out/bin/js
  '';

  passthru.tests.run = callPackage ./test.nix {
    spidermonkey = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://spidermonkey.dev/";
    license = licenses.mpl20; # TODO: MPL/GPL/LGPL tri-license for 78.
    maintainers = with maintainers; [ abbradar lostnet catap ];
    platforms = platforms.unix;
  };
})
