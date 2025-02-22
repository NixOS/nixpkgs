{ version, hash }:

{
  callPackage,
  lib,
  stdenv,
  fetchurl,
  fetchpatch,

  # build time
  buildPackages,
  cargo,
  m4,
  perl,
  pkg-config,
  python3,
  python311,
  rust-cbindgen,
  rustPlatform,
  rustc,
  which,
  zip,
  xcbuild,

  # runtime
  icu75,
  nspr,
  readline,
  zlib,
  libobjc,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "spidermonkey";
  inherit version;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    inherit hash;
  };

  patches =
    lib.optionals (lib.versionAtLeast version "102" && lib.versionOlder version "128") [
      # use pkg-config at all systems
      ./always-check-for-pkg-config.patch
      ./allow-system-s-nspr-and-icu-on-bootstrapped-sysroot.patch
    ]
    ++ lib.optionals (lib.versionAtLeast version "128") [
      # rebased version of the above 2 patches
      ./always-check-for-pkg-config-128.patch
      ./allow-system-s-nspr-and-icu-on-bootstrapped-sysroot-128.patch
    ]
    ++ lib.optionals (lib.versionAtLeast version "91" && stdenv.hostPlatform.system == "i686-linux") [
      # Fixes i686 build, https://bugzilla.mozilla.org/show_bug.cgi?id=1729459
      ./fix-float-i686.patch
    ]
    ++ lib.optionals (lib.versionAtLeast version "91" && lib.versionOlder version "102") [
      # Fix 91 compatibility with python311
      (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/mozjs91/raw/e3729167646775e60a3d8c602c0412e04f206baf/f/0001-Python-Build-Use-r-instead-of-rU-file-read-modes.patch";
        hash = "sha256-WgDIBidB9XNQ/+HacK7jxWnjOF8PEUt5eB0+Aubtl48=";
      })
    ];

  nativeBuildInputs =
    [
      cargo
      m4
      perl
      pkg-config
      # 91 does not build with python 3.12: ModuleNotFoundError: No module named 'six.moves'
      # 102 does not build with python 3.12: ModuleNotFoundError: No module named 'distutils'
      (if lib.versionOlder version "115" then python311 else python3)
      rustc
      rustc.llvmPackages.llvm # for llvm-objdump
      which
      zip
    ]
    ++ lib.optionals (lib.versionAtLeast version "128") [
      rust-cbindgen
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild
    ];

  buildInputs =
    [
      icu75
      nspr
      readline
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libobjc
      libiconv
    ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  setOutputFlags = false; # Configure script only understands --includedir

  configureFlags =
    [
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
    ]
    ++ lib.optionals (lib.versionAtLeast version "91") [
      "--disable-debug"
    ]
    ++ [
      "--disable-jemalloc"
      "--disable-strip"
      "--disable-tests"
      # Spidermonkey seems to use different host/build terminology for cross
      # compilation here.
      "--host=${stdenv.buildPlatform.config}"
      "--target=${stdenv.hostPlatform.config}"
    ];

  # mkDerivation by default appends --build/--host to configureFlags when cross compiling
  # These defaults are bogus for Spidermonkey - avoid passing them by providing an empty list
  configurePlatforms = [ ];

  enableParallelBuilding = true;

  postPatch = lib.optionalString (lib.versionOlder version "102") ''
    # This patch is a manually applied fix of
    #   https://bugzilla.mozilla.org/show_bug.cgi?id=1644600
    # Once that bug is fixed, this can be removed.
    # This is needed in, for example, `zeroad`.
    substituteInPlace js/public/StructuredClone.h \
         --replace "class SharedArrayRawBufferRefs {" \
                   "class JS_PUBLIC_API SharedArrayRawBufferRefs {"
  '';

  preConfigure =
    lib.optionalString (lib.versionAtLeast version "128") ''
      export MOZBUILD_STATE_PATH=$TMPDIR/mozbuild
    ''
    + ''
      export LIBXUL_DIST=$out
      export PYTHON="${buildPackages.python3.interpreter}"
    ''
    + lib.optionalString (lib.versionAtLeast version "91") ''
      export M4=m4
      export AWK=awk
      export AS=$CC
      export AC_MACRODIR=$PWD/build/autoconf/

    ''
    + lib.optionalString (lib.versionAtLeast version "91" && lib.versionOlder version "115") ''
      pushd js/src
      sh ../../build/autoconf/autoconf.sh --localdir=$PWD configure.in > configure
      chmod +x configure
      popd
    ''
    + lib.optionalString (lib.versionAtLeast version "115") ''
      patchShebangs build/cargo-linker
    ''
    + ''
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
    license = licenses.mpl20;
    maintainers = with maintainers; [
      abbradar
      lostnet
      catap
    ];
    broken = stdenv.hostPlatform.isDarwin && versionAtLeast version "115"; # Requires SDK 13.3 (see #242666).
    platforms = platforms.unix;
  };
})
