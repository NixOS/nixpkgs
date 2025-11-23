{
  lib,
  clangStdenv,
  buildPackages,
  runCommand,
  fetchurl,
  perl,
  python3,
  ruby,
  gi-docgen,
  bison,
  gperf,
  cmake,
  ninja,
  pkg-config,
  gettext,
  gobject-introspection,
  gnutls,
  libgcrypt,
  libgpg-error,
  gtk4,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libwebp,
  enchant2,
  xorg,
  libxkbcommon,
  libavif,
  libepoxy,
  libjxl,
  at-spi2-core,
  cairo,
  libxml2,
  libsoup_3,
  libsecret,
  libxslt,
  harfbuzz,
  hyphen,
  icu,
  libsysprof-capture,
  libpthreadstubs,
  nettle,
  libtasn1,
  p11-kit,
  libidn,
  libedit,
  readline,
  libGL,
  libGLU,
  libgbm,
  libintl,
  lcms2,
  libmanette,
  geoclue2,
  flite,
  fontconfig,
  freetype,
  openssl,
  openxr-loader,
  sqlite,
  gst-plugins-base,
  gst-plugins-bad,
  woff2,
  bubblewrap,
  libseccomp,
  libbacktrace,
  systemd,
  xdg-dbus-proxy,
  replaceVars,
  glib,
  unifdef,
  addDriverRunpath,
  enableGeoLocation ? true,
  enableExperimental ? false,
  withLibsecret ? true,
  systemdSupport ? lib.meta.availableOn clangStdenv.hostPlatform systemd,
  testers,
  fetchpatch,
}:

let
  abiVersion = if lib.versionAtLeast gtk4.version "4.0" then "6.0" else "4.1";
in

# https://webkitgtk.org/2024/10/04/webkitgtk-2.46.html recommends building with clang.
clangStdenv.mkDerivation (finalAttrs: {
  pname = "webkitgtk";
  version = "2.50.2";
  name = "webkitgtk-${finalAttrs.version}+abi=${abiVersion}";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  # https://github.com/NixOS/nixpkgs/issues/153528
  # Can't be linked within a 4GB address space.
  separateDebugInfo = clangStdenv.hostPlatform.isLinux && !clangStdenv.hostPlatform.is32bit;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/webkitgtk-${finalAttrs.version}.tar.xz";
    hash = "sha256-Gath8tROYs1ENnOUPS1TQbhNCEBfZ6fDe3p3rTVQ+IA=";
  };

  patches = lib.optionals clangStdenv.hostPlatform.isLinux [
    (replaceVars ./fix-bubblewrap-paths.patch {
      inherit (builtins) storeDir;
      inherit (addDriverRunpath) driverLink;
    })

    # Workaround to fix cross-compilation for RiscV
    # error: ‘toB3Type’ was not declared in this scope
    # See: https://bugs.webkit.org/show_bug.cgi?id=271371
    (fetchpatch {
      url = "https://salsa.debian.org/webkit-team/webkit/-/raw/debian/2.44.1-1/debian/patches/fix-ftbfs-riscv64.patch";
      hash = "sha256-MgaSpXq9l6KCLQdQyel6bQFHG53l3GY277WePpYXdjA=";
      name = "fix_ftbfs_riscv64.patch";
    })

    # Remove the CustomToJSObject flag to avoid a link error due to an undefined toJS() symbol
    (fetchpatch {
      url = "https://github.com/WebKit/WebKit/commit/730bffd856d2a1e56dd3bd2a0702282f19c5242a.patch";
      hash = "sha256-QRgYzr1Flk9BOV74/H7/38sRwc44BFFBhnX+xODgYX4=";
    })
  ];

  nativeBuildInputs = [
    bison
    cmake
    gettext
    gobject-introspection
    gperf
    ninja
    perl
    perl.pkgs.FileCopyRecursive # used by copy-user-interface-resources.pl
    pkg-config
    python3
    ruby
    gi-docgen
    glib # for gdbus-codegen
    unifdef
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    wayland-scanner
  ];

  buildInputs = [
    at-spi2-core
    cairo # required even when using skia
    enchant2
    flite
    libavif
    libepoxy
    libjxl
    gnutls
    gst-plugins-bad
    gst-plugins-base
    harfbuzz
    hyphen
    icu
    libGL
    libGLU
    libgbm
    libgcrypt
    libgpg-error
    libidn
    libintl
    lcms2
    libpthreadstubs
    libsysprof-capture
    libtasn1
    libwebp
    libxkbcommon
    libxml2
    libxslt
    libbacktrace
    nettle
    p11-kit
    sqlite
    woff2
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isBigEndian [
    # https://bugs.webkit.org/show_bug.cgi?id=274032
    fontconfig
    freetype
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
    libedit
    readline
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    libseccomp
    libmanette
    wayland
    xorg.libX11
  ]
  ++ lib.optionals systemdSupport [
    systemd
  ]
  ++ lib.optionals enableGeoLocation [
    geoclue2
  ]
  ++ lib.optionals enableExperimental [
    # For ENABLE_WEB_RTC
    openssl
    # For ENABLE_WEBXR
    openxr-loader
  ]
  ++ lib.optionals withLibsecret [
    libsecret
  ]
  ++ lib.optionals (lib.versionAtLeast gtk4.version "4.0") [
    wayland-protocols
  ];

  propagatedBuildInputs = [
    gtk4
    libsoup_3
  ];

  cmakeFlags =
    let
      cmakeBool = x: if x then "ON" else "OFF";
    in
    [
      "-DENABLE_INTROSPECTION=ON"
      "-DPORT=GTK"
      "-DUSE_SOUP2=${cmakeBool false}"
      "-DUSE_LIBSECRET=${cmakeBool withLibsecret}"
      "-DENABLE_EXPERIMENTAL_FEATURES=${cmakeBool enableExperimental}"
    ]
    ++ lib.optionals clangStdenv.hostPlatform.isLinux [
      # Have to be explicitly specified when cross.
      # https://github.com/WebKit/WebKit/commit/a84036c6d1d66d723f217a4c29eee76f2039a353
      "-DBWRAP_EXECUTABLE=${lib.getExe bubblewrap}"
      "-DDBUS_PROXY_EXECUTABLE=${lib.getExe xdg-dbus-proxy}"
    ]
    ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
      "-DENABLE_GAMEPAD=OFF"
      "-DENABLE_GTKDOC=OFF"
      "-DENABLE_MINIBROWSER=OFF"
      "-DENABLE_QUARTZ_TARGET=ON"
      "-DENABLE_X11_TARGET=OFF"
      "-DUSE_APPLE_ICU=OFF"
      "-DUSE_OPENGL_OR_ES=OFF"
    ]
    ++ lib.optionals (lib.versionOlder gtk4.version "4.0") [
      "-DUSE_GTK4=OFF"
    ]
    ++ lib.optionals (!systemdSupport) [
      "-DENABLE_JOURNALD_LOG=OFF"
    ];

  postPatch = ''
    patchShebangs .
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Web content rendering engine, GTK port";
    mainProgram = "WebKitWebDriver";
    homepage = "https://webkitgtk.org/";
    license = licenses.bsd2;
    pkgConfigModules =
      if lib.versionAtLeast abiVersion "6.0" then
        [
          "javascriptcoregtk-${abiVersion}"
          "webkitgtk-${abiVersion}"
          "webkitgtk-web-process-extension-${abiVersion}"
        ]
      else
        [
          "javascriptcoregtk-${abiVersion}"
          "webkit2gtk-${abiVersion}"
          "webkit2gtk-web-extension-${abiVersion}"
        ];
    platforms = platforms.linux ++ platforms.darwin;
    teams = [ teams.gnome ];
    broken = clangStdenv.hostPlatform.isDarwin;
  };
})
