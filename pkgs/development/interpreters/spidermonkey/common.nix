{ version, hash }:

{
  callPackage,
  lib,
  stdenv,
  fetchurl,
  fetchpatch,

  # build time
  apple-sdk_14,
  apple-sdk_15,
  buildPackages,
  cargo,
  m4,
  perl,
  pkg-config,
  python3,
  rust-cbindgen,
  rustPlatform,
  rustc,
  which,
  zip,
  xcbuild,

  # runtime
  icu75,
  icu77,
  nspr,
  readline,
  zlib,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
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
    lib.optionals (lib.versionOlder version "128") [
      # use pkg-config at all systems
      ./always-check-for-pkg-config.patch
      ./allow-system-s-nspr-and-icu-on-bootstrapped-sysroot.patch
    ]
    ++ lib.optionals (lib.versionAtLeast version "128") [
      # rebased version of the above 2 patches
      ./always-check-for-pkg-config-128.patch
      ./allow-system-s-nspr-and-icu-on-bootstrapped-sysroot-128.patch
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "i686-linux") [
      # Fixes i686 build, https://bugzilla.mozilla.org/show_bug.cgi?id=1729459
      ./fix-float-i686.patch
    ]
    ++ lib.optionals (lib.versionAtLeast version "140") [
      # mozjs-140.pc does not contain -DXP_UNIX on Linux
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1973994
      (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/mozjs140/raw/49492baa47bc1d7b7d5bc738c4c81b4661302f27/f/9aa8b4b051dd539e0fbd5e08040870b3c712a846.patch";
        hash = "sha256-SsyO5g7wlrxE7y2+VTHfmUDamofeZVqge8fv2y0ZhuU=";
      })
    ];

  nativeBuildInputs = [
    cargo
    m4
    perl
    pkg-config
    python3
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

  buildInputs = [
    (if (lib.versionAtLeast version "140") then icu77 else icu75)
    nspr
    readline
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    (if (lib.versionAtLeast version "140") then apple-sdk_15 else apple-sdk_14)
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
    "--disable-debug"
  ]
  ++ lib.optionals (lib.versionAtLeast version "140") [
    # For pkgconfig file.
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1907030
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1957023
    "--includedir=${placeholder "dev"}/include"
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

  preConfigure =
    lib.optionalString (lib.versionAtLeast version "128") ''
      export MOZBUILD_STATE_PATH=$TMPDIR/mozbuild
    ''
    + ''
      export LIBXUL_DIST=$out
      export PYTHON="${buildPackages.python3.interpreter}"
      export M4=m4
      export AWK=awk
      export AS=$CC
      export AC_MACRODIR=$PWD/build/autoconf/
      patchShebangs build/cargo-linker
      # We can't build in js/src/, so create a build dir
      mkdir obj
      cd obj/
      configureScript=../js/src/configure
    '';

  env = lib.optionalAttrs (lib.versionAtLeast version "140") {
    # '-Wformat-security' ignored without '-Wformat'
    NIX_CFLAGS_COMPILE = "-Wformat";
  };

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
      lostnet
      catap
      bobby285271
    ];
    # ERROR: Failed to find an adequate linker
    broken = lib.versionOlder version "128" && stdenv.hostPlatform.isDarwin;
    platforms = platforms.unix;
  };
})
