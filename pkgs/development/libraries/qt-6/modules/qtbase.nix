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
, xlibsWrapper
, xorg
, zstd
, double-conversion
, util-linux
, systemd
, libb2
, md4c
, mtdev
, lksctp-tools
, libselinux
, libsepol
, vulkan-headers
, vulkan-loader
, valgrind
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
  # optional dependencies
, cups
, libmysqlclient
, postgresql
, withGtk3 ? false
, dconf
, gtk3
  # options
, libGLSupported ? true
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
    xlibsWrapper
    zstd
    double-conversion
    util-linux
    systemd
    libb2
    md4c
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
    valgrind
    dbus
    glib
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
  ] ++ (with unixODBCDrivers; [
    psql
    sqlite
    mariadb
  ]) ++ lib.optional libGLSupported libGL;

  buildInputs = [
    python3
    at-spi2-core
    libinput
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
    "-DQT_FEATURE_journald=ON"
    "-DQT_FEATURE_sctp=ON"
    "-DQT_FEATURE_libproxy=ON"
    "-DQT_FEATURE_system_sqlite=ON"
    "-DQT_FEATURE_vulkan=ON"
    "-DQT_FEATURE_openssl_linked=ON"
  ];

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
    moveToOutput bin "$dev"
    moveToOutput libexec "$dev"

    # fixup .pc file (where to find 'moc' etc.)
    sed -i "$dev/lib/pkgconfig/Qt6Core.pc" \
      -e "/^bindir=/ c bindir=$dev/bin"

    patchShebangs $out $dev
  '';

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ milahu nickcao LunNova ];
    platforms = platforms.linux;
  };
}
