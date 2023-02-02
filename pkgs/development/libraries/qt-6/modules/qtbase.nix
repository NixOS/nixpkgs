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
, xcbuild
, AGL
, AVFoundation
, AppKit
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
}:

let
  debugSymbols = debug || developerBuild;
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
    dbus
    glib
    # unixODBC drivers
    unixODBCDrivers.psql
    unixODBCDrivers.sqlite
    unixODBCDrivers.mariadb
  ] ++ lib.optionals systemdSupport [
    systemd
  ] ++ lib.optionals stdenv.isLinux [
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
    GSS
    MetalKit
  ] ++ lib.optional libGLSupported libGL;

  buildInputs = [
    python3
    at-spi2-core
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libinput
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    AppKit
  ]
  ++ lib.optional withGtk3 gtk3
  ++ lib.optional developerBuild gdb
  ++ lib.optional (cups != null) cups
  ++ lib.optional (libmysqlclient != null) libmysqlclient
  ++ lib.optional (postgresql != null) postgresql;

  nativeBuildInputs = [ bison flex gperf lndir perl pkg-config which cmake xmlstarlet ninja ];

  propagatedNativeBuildInputs = [ lndir ];

  enableParallelBuilding = true;

  inherit patches;

  # https://bugreports.qt.io/browse/QTBUG-97568
  postPatch = ''
    substituteInPlace src/corelib/CMakeLists.txt --replace /bin/ls ${coreutils}/bin/ls
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/QtAutoDetect.cmake --replace "/usr/bin/xcrun" "${xcbuild}/bin/xcrun"
  '';

  fix_qt_builtin_paths = ../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = ../hooks/fix-qt-module-paths.sh;
  preHook = ''
    . "$fix_qt_builtin_paths"
    . "$fix_qt_module_paths"
    . ${../hooks/move-qt-dev-tools.sh}
    . ${../hooks/fix-qmake-libtool.sh}
  '';

  qtPluginPrefix = "lib/qt-6/plugins";
  qtQmlPrefix = "lib/qt-6/qml";

  cmakeFlags = [
    "-DINSTALL_PLUGINSDIR=${qtPluginPrefix}"
    "-DINSTALL_QMLDIR=${qtQmlPrefix}"
    "-DQT_FEATURE_libproxy=ON"
    "-DQT_FEATURE_system_sqlite=ON"
    "-DQT_FEATURE_openssl_linked=ON"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DQT_FEATURE_sctp=ON"
    "-DQT_FEATURE_journald=${if systemdSupport then "ON" else "OFF"}"
    "-DQT_FEATURE_vulkan=ON"
  ] ++ lib.optionals stdenv.isDarwin [
    # build as a set of dynamic libraries
    "-DFEATURE_framework=OFF"
  ];

  NIX_LDFLAGS = toString (lib.optionals stdenv.isDarwin [
    # Undefined symbols for architecture arm64: "___gss_c_nt_hostbased_service_oid_desc"
    "-framework GSS"
  ]);

  outputs = [ "out" "dev" ];

  postInstall = ''
    moveToOutput "mkspecs" "$dev"
  '';

  devTools = [
    "libexec/moc"
    "libexec/rcc"
    "libexec/syncqt.pl"
    "libexec/qlalr"
    "libexec/ensure_pro_file.cmake"
    "libexec/cmake_automoc_parser"
    "libexec/qvkgen"
    "libexec/tracegen"
    "libexec/uic"
    "bin/fixqt4headers.pl"
    "bin/moc"
    "bin/qdbuscpp2xml"
    "bin/qdbusxml2cpp"
    "bin/qlalr"
    "bin/qmake"
    "bin/qmake6"
    "bin/qt-cmake"
    "bin/qt-cmake-private"
    "bin/qt-cmake-private-install.cmake"
    "bin/qt-cmake-standalone-test"
    "bin/rcc"
    "bin/syncqt.pl"
    "bin/uic"
  ];

  postFixup = ''
    # Don't retain build-time dependencies like gdb.
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    fixQtModulePaths "''${!outputDev}/mkspecs/modules"
    fixQtBuiltinPaths "''${!outputDev}" '*.pr?'

    # Move development tools to $dev
    moveQtDevTools
    moveToOutput libexec "$dev"

    # fixup .pc file (where to find 'moc' etc.)
    if [ -f "$dev/lib/pkgconfig/Qt6Core.pc" ]; then
      sed -i "$dev/lib/pkgconfig/Qt6Core.pc" \
        -e "/^bindir=/ c bindir=$dev/bin" \
        -e "/^libexecdir=/ c libexecdir=$dev/libexec"
    fi

    patchShebangs $out $dev

    # QTEST_ASSERT and other macros keeps runtime reference to qtbase.dev
    if [ -f "$dev/include/QtTest/qtestassert.h" ]; then
      substituteInPlace "$dev/include/QtTest/qtestassert.h" --replace "__FILE__" "__BASE_FILE__"
    fi
  '';

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
