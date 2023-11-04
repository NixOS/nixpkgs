{ stdenv
, lib
, src
, patches ? [ ]
, version
, coreutils
, bison
, flex
, gdb
, gperf
, lndir
, perl
, pkg-config
, python3
, which
, cmake
, ninja
, ccache
, xmlstarlet
, libproxy
, xorg
, zstd
, double-conversion
, util-linux
, systemd
, systemdSupport ? stdenv.isLinux
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
, libiconv
, dbus
, dbusSupport ? true
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
, odbcSupport ? stdenv.buildPlatform == stdenv.hostPlatform
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
  # optional dependencies
, cups
, libmysqlclient
, postgresql
, withGtk3 ? false
, dconf
, gtk3
  # options
, libGLSupported ? stdenv.isLinux
, libGL
, debug ? false
, developerBuild ? false
, qttranslations ? null
, buildPackages
, pkgsBuildHost
, writeText
}:

let
  debugSymbols = debug || developerBuild;

  # Cross Compilation support
  #
  # NOTE!  You must use `targetPlatform` instead of `hostPlatform`
  # almost everywhere in this file.  This is necessary because our
  # qtbase expression has "the GCC problem": it builds both a
  # compiler-like tool (qmake) and its target libraries (qtbase) as
  # part of a single derivation.  We should stop doing this.

  qtPlatformCross = plat: with plat;
    if isLinux
    then "linux-generic-g++"
    else throw "Please add a qtPlatformCross entry for ${plat.config}";

  specsDirName = "nixpkgs-${stdenv.targetPlatform.config}";
  specsFile = writeText "qmake.conf" (''
    MAKEFILE_GENERATOR      = UNIX
    CONFIG                 += incremental
    QMAKE_INCREMENTAL_STYLE = sublib
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    include(../common/linux.conf)
  '' + lib.optionalString stdenv.cc.isGNU ''
    include(../common/gcc-base-unix.conf)
    include(../common/g++-unix.conf)
  '' + ''
    QMAKE_CC                = ${stdenv.cc.targetPrefix}gcc
    QMAKE_CXX               = ${stdenv.cc.targetPrefix}g++
    QMAKE_LINK              = ${stdenv.cc.targetPrefix}g++
    QMAKE_LINK_SHLIB        = ${stdenv.cc.targetPrefix}g++
    QMAKE_AR                = ${stdenv.cc.targetPrefix}ar cqs
    QMAKE_OBJCOPY           = ${stdenv.cc.targetPrefix}objcopy
    QMAKE_NM                = ${stdenv.cc.targetPrefix}nm -P
    QMAKE_STRIP             = ${stdenv.cc.targetPrefix}strip
    load(qt_config)
  '');

in
stdenv.mkDerivation rec {
  pname = "qtbase";

  inherit src version;

  debug = debugSymbols;

  propagatedBuildInputs = [
    libxml2
    libxslt
    openssl
    sqlite
    zlib
    unixODBC
    # Text rendering
    harfbuzz
    icu
    # Image formats
    libjpeg
    libpng
    pcre2
    pcre
    libproxy
    zstd
    double-conversion
    libb2
    md4c
  ] ++ lib.optionals dbusSupport [
    dbus
  ] ++ [
    glib
  ] ++ lib.optionals odbcSupport [
    # unixODBC drivers
    unixODBCDrivers.psql
    unixODBCDrivers.sqlite
    unixODBCDrivers.mariadb
  ] ++ lib.optionals systemdSupport [
    systemd
  ] ++ lib.optionals stdenv.targetPlatform.isLinux [
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
  ] ++ lib.optionals stdenv.isDarwin [
    AGL
    AVFoundation
    AppKit
    Contacts
    CoreBluetooth
    EventKit
    GSS
    MetalKit
  ] ++ lib.optional libGLSupported libGL;

  buildInputs = [
    python3
  ] ++ lib.optionals dbusSupport [
    at-spi2-core
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libinput
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    AppKit
    CoreBluetooth
  ]
  ++ lib.optional withGtk3 gtk3
  ++ lib.optional developerBuild gdb
  ++ lib.optional (cups != null) cups
  ++ lib.optional (libmysqlclient != null) libmysqlclient
  ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which cmake xmlstarlet ninja ]
    ++ lib.optionals stdenv.isDarwin [ moveBuildTree ];

  propagatedNativeBuildInputs = [ lndir ];

  strictDeps = true;

  enableParallelBuilding = true;

  inherit patches;

  # https://bugreports.qt.io/browse/QTBUG-97568
  postPatch = ''
    substituteInPlace src/corelib/CMakeLists.txt --replace /bin/ls ${coreutils}/bin/ls
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/QtAutoDetect.cmake --replace "/usr/bin/xcrun" "${xcbuild}/bin/xcrun"
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.targetPlatform) ''
    install -DT ${specsFile}            mkspecs/${specsDirName}/qmake.conf
    ln -s ../linux-g++/qplatformdefs.h  mkspecs/${specsDirName}/qplatformdefs.h
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
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DQT_FEATURE_sctp=ON"
    "-DQT_FEATURE_journald=${if systemdSupport then "ON" else "OFF"}"
    "-DQT_FEATURE_vulkan=ON"
    "-DQT_FEATURE_dbus=${if dbusSupport then "ON" else "OFF"}"
  ] ++ lib.optionals stdenv.isDarwin [
    # error: 'path' is unavailable: introduced in macOS 10.15
    "-DQT_FEATURE_cxx17_filesystem=OFF"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.targetPlatform) [
    # Useful: https://raw.githubusercontent.com/qt/qtbase/dev/cmake/configure-cmake-mapping.md
    #"-DQT_QMAKE_TARGET_MKSPEC=${specsDirName}"
    #"-DFEATURE_thread=ON"
    #"-DQT_BUILD_SHARED_LIBS=ON"
    #"-DQT_FORCE_BUILD_TOOLS=TRUE"
    "-DQT_QMAKE_TARGET_MKSPEC=devices/${qtPlatformCross stdenv.hostPlatform}"
    "-DQT_QMAKE_DEVICE_OPTIONS=CROSS_COMPILE=${stdenv.cc.targetPrefix}"

    #"-DQT_INSTALL_PREFIX=${builtins.placeholder "out"}"
    "-DQT_HOST_PREFIX=${pkgsBuildHost.qt6Packages.qtbase}"
  ]
  #++ lib.optional (qttranslations != null) "-DINSTALL_TRANSLATIONSDIR=${qttranslations}/translations"
  ;

  NIX_LDFLAGS = toString (lib.optionals stdenv.isDarwin [
    # Undefined symbols for architecture arm64: "___gss_c_nt_hostbased_service_oid_desc"
    "-framework GSS"
  ]);

  outputs = [ "out" "dev" ];

  moveToDev = false;

  postFixup = ''
    moveToOutput      "mkspecs/modules" "$dev"
    fixQtModulePaths  "$dev/mkspecs/modules"
    fixQtBuiltinPaths "$out" '*.pr?'
  ''
  + lib.optionalString (stdenv.buildPlatform != stdenv.targetPlatform) ''
    ln -s "${pkgsBuildHost.qt6Packages.qtbase}/libexec/moc" $out/libexec/moc || true
  ''
  ;

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13Plus gpl2Plus lgpl21Plus lgpl3Plus ];
    maintainers = with maintainers; [ milahu nickcao LunNova ];
    platforms = platforms.unix;
  };
}
