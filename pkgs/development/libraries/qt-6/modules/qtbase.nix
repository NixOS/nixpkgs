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
, libXcursor
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

  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/build/lib:$PWD/build/plugins/platforms''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
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
    mkdir -p $dev
    mv $out/mkspecs $out/bin $out/libexec $dev/
  '';

  dontStrip = debugSymbols;

  setupHook = ../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
    maintainers = with maintainers; [ milahu nickcao ];
    platforms = platforms.linux;
  };
}
