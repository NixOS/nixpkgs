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
  gtk3,
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
  libsoup,
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
}:

# https://webkitgtk.org/2024/10/04/webkitgtk-2.46.html recommends building with clang.
clangStdenv.mkDerivation (finalAttrs: {
  pname = "webkitgtk";
  version = "2.50.0";
  name = "${finalAttrs.pname}-${finalAttrs.version}+abi=${
    if lib.versionAtLeast gtk3.version "4.0" then
      "6.0"
    else
      "4.${if lib.versions.major libsoup.version == "2" then "0" else "1"}"
  }";

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
    hash = "sha256-5WS4CZ+aOuMkCVObKQu9KtCE6ZttItSqxeUeRVTfi8I=";
  };

  patches = lib.optionals clangStdenv.hostPlatform.isLinux [
    (replaceVars ./fix-bubblewrap-paths.patch {
      inherit (builtins) storeDir;
      inherit (addDriverRunpath) driverLink;
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
  ++ lib.optionals (lib.versionAtLeast gtk3.version "4.0") [
    wayland-protocols
  ];

  propagatedBuildInputs = [
    gtk3
    libsoup
  ];

  cmakeFlags =
    let
      cmakeBool = x: if x then "ON" else "OFF";
    in
    [
      "-DENABLE_INTROSPECTION=ON"
      "-DPORT=GTK"
      "-DUSE_SOUP2=${cmakeBool (lib.versions.major libsoup.version == "2")}"
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
    ++ lib.optionals (lib.versionOlder gtk3.version "4.0") [
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
    pkgConfigModules = [
      "javascriptcoregtk-4.0"
      "webkit2gtk-4.0"
      "webkit2gtk-web-extension-4.0"
    ];
    platforms = platforms.linux ++ platforms.darwin;
    teams = [ teams.gnome ];
    broken = clangStdenv.hostPlatform.isDarwin;
  };
})
