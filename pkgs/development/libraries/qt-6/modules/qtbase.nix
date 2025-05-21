{ stdenv
, lib
, src
, patches ? [ ]
, version
, bison
, flex
, gperf
, lndir
, perl
, pkg-config
, which
, cmake
, ninja
, xmlstarlet
, libproxy
, xorg
, zstd
, double-conversion
, util-linux
, systemd
, systemdSupport ? stdenv.hostPlatform.isLinux
, libb2
, md4c
, mtdev
, lksctp-tools
, libselinux
, libsepol
, vulkan-headers
, vulkan-loader
, libthai
, libdrm
, libdatrie
, lttng-ust
, libepoxy
, dbus
, fontconfig
, freetype
, glib
, harfbuzz
, icu
, libX11
, libXcomposite
, libXext
, libXi
, libXrender
, libinput
, libjpeg
, libpng
, libxcb
, libxkbcommon
, libxml2
, libxslt
, openssl
, pcre
, pcre2
, sqlite
, udev
, xcbutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
, zlib
, at-spi2-core
, unixODBC
, unixODBCDrivers
  # darwin
, moveBuildTree
, xcbuild
, AGL
, AVFoundation
, AppKit
, Contacts
, CoreBluetooth
, EventKit
, GSS
, MetalKit
  # mingw
, pkgsBuildBuild
  # optional dependencies
, cups
, libmysqlclient
, postgresql
, withGtk3 ? false
, dconf
, gtk3
  # options
, libGLSupported ? stdenv.hostPlatform.isLinux
, libGL
, qttranslations ? null
}:

let
  isCrossBuild = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
stdenv.mkDerivation rec {
  pname = "qtbase";

  inherit src version;

  propagatedBuildInputs = [
    libxml2
    libxslt
    openssl
    sqlite
    zlib
    # Text rendering
    harfbuzz
    icu
    # Image formats
    libjpeg
    libpng
    pcre2
    pcre
    zstd
    libb2
    md4c
    double-conversion
  ] ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [
    libproxy
    dbus
    glib
    # unixODBC drivers
    unixODBC
    unixODBCDrivers.psql
    unixODBCDrivers.sqlite
    unixODBCDrivers.mariadb
  ] ++ lib.optionals systemdSupport [
    systemd
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linux
    mtdev
    lksctp-tools
    libselinux
    libsepol
    lttng-ust
    vulkan-headers
    vulkan-loader
    libthai
    libdrm
    libdatrie
    udev
    # Text rendering
    fontconfig
    freetype
    # X11 libs
    libX11
    libXcomposite
    libXext
    libXi
    libXrender
    libxcb
    libxkbcommon
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    xorg.libXdmcp
    xorg.libXtst
    xorg.xcbutilcursor
    libepoxy
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    AGL
    AVFoundation
    AppKit
    Contacts
    CoreBluetooth
    EventKit
    GSS
    MetalKit
  ] ++ lib.optionals libGLSupported [
    libGL
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    vulkan-headers
    vulkan-loader
  ];

  buildInputs = lib.optionals (lib.meta.availableOn stdenv.hostPlatform at-spi2-core) [
    at-spi2-core
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform libinput) [
    libinput
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    AppKit
    CoreBluetooth
  ]
  ++ lib.optional withGtk3 gtk3
  ++ lib.optional (cups != null && lib.meta.availableOn stdenv.hostPlatform cups) cups
  ++ lib.optional (libmysqlclient != null && !stdenv.hostPlatform.isMinGW) libmysqlclient
  ++ lib.optional (postgresql != null && lib.meta.availableOn stdenv.hostPlatform postgresql) postgresql;

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which cmake xmlstarlet ninja ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ moveBuildTree ];

  propagatedNativeBuildInputs = [ lndir ];

  strictDeps = true;

  enableParallelBuilding = true;

  inherit patches;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/QtPublicAppleHelpers.cmake --replace-fail "/usr/bin/xcrun" "${xcbuild}/bin/xcrun"
  '';

  fix_qt_builtin_paths = ../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = ../hooks/fix-qt-module-paths.sh;
  preHook = ''
    . "$fix_qt_builtin_paths"
    . "$fix_qt_module_paths"
  '';

  qtPluginPrefix = "lib/qt-6/plugins";
  qtQmlPrefix = "lib/qt-6/qml";

  cmakeFlags = [
    "-DQT_EMBED_TOOLCHAIN_COMPILER=OFF"
    "-DINSTALL_PLUGINSDIR=${qtPluginPrefix}"
    "-DINSTALL_QMLDIR=${qtQmlPrefix}"
    "-DQT_FEATURE_libproxy=ON"
    "-DQT_FEATURE_system_sqlite=ON"
    "-DQT_FEATURE_openssl_linked=ON"
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "-DQT_FEATURE_sctp=ON"
    "-DQT_FEATURE_journald=${if systemdSupport then "ON" else "OFF"}"
    "-DQT_FEATURE_vulkan=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # error: 'path' is unavailable: introduced in macOS 10.15
    "-DQT_FEATURE_cxx17_filesystem=OFF"
  ] ++ lib.optionals isCrossBuild [
    "-DQT_HOST_PATH=${pkgsBuildBuild.qt6.qtbase}"
    "-DQt6HostInfo_DIR=${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6HostInfo"
  ]
  ++ lib.optional (qttranslations != null && !isCrossBuild) "-DINSTALL_TRANSLATIONSDIR=${qttranslations}/translations";

  env.NIX_LDFLAGS = toString (lib.optionals stdenv.hostPlatform.isDarwin [
    # Undefined symbols for architecture arm64: "___gss_c_nt_hostbased_service_oid_desc"
    "-framework GSS"
  ]);

  env.NIX_CFLAGS_COMPILE = "-DNIXPKGS_QT_PLUGIN_PREFIX=\"${qtPluginPrefix}\"";

  outputs = [ "out" "dev" ];

  moveToDev = false;

  postFixup = ''
    moveToOutput      "mkspecs/modules" "$dev"
    fixQtModulePaths  "$dev/mkspecs/modules"
    fixQtBuiltinPaths "$out" '*.pr?'
  '' + lib.optionalString stdenv.isLinux ''

    # FIXME: not sure why this isn't added automatically?
    patchelf --add-rpath "${libmysqlclient}/lib/mariadb" $out/${qtPluginPrefix}/sqldrivers/libqsqlmysql.so
  '';

  dontWrapQtApps = true;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "Cross-platform application framework for C++";
    license = with licenses; [ fdl13Plus gpl2Plus lgpl21Plus lgpl3Plus ];
    maintainers = with maintainers; [ milahu nickcao LunNova ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
