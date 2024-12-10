{
  lib,
  stdenv,
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
  libwebp,
  enchant2,
  xorg,
  libxkbcommon,
  libavif,
  libepoxy,
  libjxl,
  at-spi2-core,
  libxml2,
  libsoup,
  libsecret,
  libxslt,
  harfbuzz,
  libpthreadstubs,
  nettle,
  libtasn1,
  p11-kit,
  libidn,
  libedit,
  readline,
  apple_sdk,
  libGL,
  libGLU,
  mesa,
  libintl,
  lcms2,
  libmanette,
  geoclue2,
  sqlite,
  gst-plugins-base,
  gst-plugins-bad,
  woff2,
  bubblewrap,
  libseccomp,
  libbacktrace,
  systemd,
  xdg-dbus-proxy,
  substituteAll,
  glib,
  unifdef,
  addOpenGLRunpath,
  enableGeoLocation ? true,
  withLibsecret ? true,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webkitgtk";
  version = "2.44.3";
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
  separateDebugInfo = stdenv.isLinux && !stdenv.is32bit;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/webkitgtk-${finalAttrs.version}.tar.xz";
    hash = "sha256-3ILQQuysqYGkhSNXwG5SNXQzGc8QqUzTatQbl4g6C1Q=";
  };

  patches = lib.optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
      inherit (addOpenGLRunpath) driverLink;
    })
  ];

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    # Ignore gettext in cmake_prefix_path so that find_program doesn't
    # pick up the wrong gettext. TODO: Find a better solution for
    # this, maybe make cmake not look up executables in
    # CMAKE_PREFIX_PATH.
    cmakeFlags+=" -DCMAKE_IGNORE_PATH=${lib.getBin gettext}/bin"
  '';

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
  ];

  buildInputs =
    [
      at-spi2-core
      enchant2
      libavif
      libepoxy
      libjxl
      gnutls
      gst-plugins-bad
      gst-plugins-base
      harfbuzz
      libGL
      libGLU
      mesa # for libEGL headers
      libgcrypt
      libgpg-error
      libidn
      libintl
      lcms2
      libpthreadstubs
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
    ++ lib.optionals stdenv.isDarwin [
      libedit
      readline
    ]
    ++ lib.optional (stdenv.isDarwin && !stdenv.isAarch64) (
      # Pull a header that contains a definition of proc_pid_rusage().
      # (We pick just that one because using the other headers from `sdk` is not
      # compatible with our C++ standard library. This header is already in
      # the standard library on aarch64)
      runCommand "webkitgtk_headers" { } ''
        install -Dm444 "${lib.getDev apple_sdk.sdk}"/include/libproc.h "$out"/include/libproc.h
      ''
    )
    ++ lib.optionals stdenv.isLinux [
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
      "-DUSE_LIBHYPHEN=OFF"
      "-DUSE_SOUP2=${cmakeBool (lib.versions.major libsoup.version == "2")}"
      "-DUSE_LIBSECRET=${cmakeBool withLibsecret}"
    ]
    ++ lib.optionals stdenv.isLinux [
      # Have to be explicitly specified when cross.
      # https://github.com/WebKit/WebKit/commit/a84036c6d1d66d723f217a4c29eee76f2039a353
      "-DBWRAP_EXECUTABLE=${lib.getExe bubblewrap}"
      "-DDBUS_PROXY_EXECUTABLE=${lib.getExe xdg-dbus-proxy}"
      "-DWAYLAND_SCANNER=${buildPackages.wayland-scanner}/bin/wayland-scanner"
    ]
    ++ lib.optionals stdenv.isDarwin [
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
    maintainers = teams.gnome.members;
    broken = stdenv.isDarwin;
  };
})
