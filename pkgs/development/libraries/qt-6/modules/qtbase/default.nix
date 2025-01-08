{
  stdenv,
  lib,
  src,
  version,
  bison,
  flex,
  gperf,
  lndir,
  perl,
  pkg-config,
  which,
  cmake,
  ninja,
  xmlstarlet,
  libproxy,
  xorg,
  zstd,
  double-conversion,
  util-linux,
  systemd,
  systemdSupport ? stdenv.hostPlatform.isLinux,
  libb2,
  md4c,
  mtdev,
  lksctp-tools,
  libselinux,
  libsepol,
  vulkan-headers,
  vulkan-loader,
  libthai,
  libdrm,
  libdatrie,
  lttng-ust,
  libepoxy,
  dbus,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  icu,
  libX11,
  libXcomposite,
  libXext,
  libXi,
  libXrender,
  libjpeg,
  libpng,
  libxcb,
  libxkbcommon,
  libxml2,
  libxslt,
  openssl,
  pcre,
  pcre2,
  sqlite,
  udev,
  xcbutil,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
  zlib,
  at-spi2-core,
  unixODBC,
  unixODBCDrivers,
  # darwin
  moveBuildTree,
  darwinVersionInputs,
  xcbuild,
  # mingw
  pkgsBuildBuild,
  # optional dependencies
  cups,
  libmysqlclient,
  postgresql,
  withGtk3 ? false,
  gtk3,
  withLibinput ? false,
  libinput,
  # options
  libGLSupported ? stdenv.hostPlatform.isLinux,
  libGL,
  qttranslations ? null,
}:

let
  isCrossBuild = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
stdenv.mkDerivation rec {
  pname = "qtbase";

  inherit src version;

  propagatedBuildInputs =
    [
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
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [
      libproxy
      dbus
      glib
      # unixODBC drivers
      unixODBC
      unixODBCDrivers.psql
      unixODBCDrivers.sqlite
      unixODBCDrivers.mariadb
    ]
    ++ lib.optionals systemdSupport [
      systemd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
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
    ]
    ++ lib.optionals libGLSupported [
      libGL
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optional (cups != null && lib.meta.availableOn stdenv.hostPlatform cups) cups;

  buildInputs =
    lib.optionals (lib.meta.availableOn stdenv.hostPlatform at-spi2-core) [
      at-spi2-core
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin darwinVersionInputs
    ++ lib.optional withGtk3 gtk3
    ++ lib.optional withLibinput libinput
    ++ lib.optional (libmysqlclient != null && !stdenv.hostPlatform.isMinGW) libmysqlclient
    ++ lib.optional (
      postgresql != null && lib.meta.availableOn stdenv.hostPlatform postgresql
    ) postgresql;

  nativeBuildInputs = [
    bison
    flex
    gperf
    lndir
    perl
    pkg-config
    which
    cmake
    xmlstarlet
    ninja
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ moveBuildTree ];

  propagatedNativeBuildInputs =
    [ lndir ]
    # I’m not sure if this is necessary, but the macOS mkspecs stuff
    # tries to call `xcrun xcodebuild`, so better safe than sorry.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  strictDeps = true;

  enableParallelBuilding = true;

  patches = [
    # look for Qt plugins in directories on PATH
    ./derive-plugin-load-path-from-PATH.patch

    # allow translations to be found outside of install prefix, as is the case in our split builds
    ./allow-translations-outside-prefix.patch

    # always link to libraries by name in qmake-generated build scripts
    ./qmake-always-use-libname.patch
    # always explicitly list includedir in qmake-generated pkg-config files
    ./qmake-fix-includedir.patch

    # don't generate SBOM files by default, they don't work with our split installs anyway
    ./no-sbom.patch

    # use cmake from PATH in qt-cmake wrapper, to avoid qtbase runtime-depending on cmake
    ./use-cmake-from-path.patch

    # macdeployqt fixes
    # get qmlimportscanner location from environment variable
    ./find-qmlimportscanner.patch
    # pass QML2_IMPORT_PATH from environment to qmlimportscanner
    ./qmlimportscanner-import-path.patch
    # don't pass qtbase's QML directory to qmlimportscanner if it's empty
    ./skip-missing-qml-directory.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # TODO: Verify that this catches all the occurrences?
    for file in \
      cmake/QtPublicAppleHelpers.cmake \
      mkspecs/features/mac/asset_catalogs.prf \
      mkspecs/features/mac/default_pre.prf \
      mkspecs/features/mac/sdk.mk \
      mkspecs/features/mac/sdk.prf \
      mkspecs/features/permissions.prf \
      src/corelib/Qt6CoreMacros.cmake
    do
      substituteInPlace "$file" \
        --replace-quiet /usr/bin/xcrun '${lib.getExe' xcbuild "xcrun"}' \
        --replace-quiet /usr/bin/xcode-select '${lib.getExe' xcbuild "xcode-select"}' \
        --replace-quiet /usr/libexec/PlistBuddy '${lib.getExe' xcbuild "PlistBuddy"}'
    done

    substituteInPlace mkspecs/common/macx.conf \
      --replace-fail 'CONFIG += ' 'CONFIG += no_default_rpath '
  '';

  fix_qt_builtin_paths = ../../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = ../../hooks/fix-qt-module-paths.sh;
  preHook = ''
    . "$fix_qt_builtin_paths"
    . "$fix_qt_module_paths"
  '';

  qtPluginPrefix = "lib/qt-6/plugins";
  qtQmlPrefix = "lib/qt-6/qml";

  cmakeFlags =
    [
      "-DQT_EMBED_TOOLCHAIN_COMPILER=OFF"
      "-DINSTALL_PLUGINSDIR=${qtPluginPrefix}"
      "-DINSTALL_QMLDIR=${qtQmlPrefix}"
      "-DQT_FEATURE_libproxy=ON"
      "-DQT_FEATURE_system_sqlite=ON"
      "-DQT_FEATURE_openssl_linked=ON"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      "-DQT_FEATURE_sctp=ON"
      "-DQT_FEATURE_journald=${if systemdSupport then "ON" else "OFF"}"
      "-DQT_FEATURE_vulkan=ON"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DQT_FEATURE_rpath=OFF"
    ]
    ++ lib.optionals isCrossBuild [
      "-DQT_HOST_PATH=${pkgsBuildBuild.qt6.qtbase}"
      "-DQt6HostInfo_DIR=${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6HostInfo"
    ]
    ++ lib.optional (
      qttranslations != null && !isCrossBuild
    ) "-DINSTALL_TRANSLATIONSDIR=${qttranslations}/translations";

  env.NIX_CFLAGS_COMPILE = "-DNIXPKGS_QT_PLUGIN_PREFIX=\"${qtPluginPrefix}\"";

  outputs = [
    "out"
    "dev"
  ];
  separateDebugInfo = true;

  moveToDev = false;

  postFixup =
    ''
      moveToOutput      "mkspecs/modules" "$dev"
      fixQtModulePaths  "$dev/mkspecs/modules"
      fixQtBuiltinPaths "$out" '*.pr?'
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''

      # FIXME: not sure why this isn't added automatically?
      patchelf --add-rpath "${libmysqlclient}/lib/mariadb" $out/${qtPluginPrefix}/sqldrivers/libqsqlmysql.so
    '';

  dontWrapQtApps = true;

  setupHook = ../../hooks/qtbase-setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "Cross-platform application framework for C++";
    license = with licenses; [
      fdl13Plus
      gpl2Plus
      lgpl21Plus
      lgpl3Plus
    ];
    maintainers = with maintainers; [
      nickcao
      LunNova
    ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
