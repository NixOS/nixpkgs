{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  testers,
  boost,
  cmake,
  cmake-extras,
  doxygen,
  gst_all_1,
  gdk-pixbuf,
  gtest,
  makeFontsConf,
  libapparmor,
  libexif,
  libqtdbustest,
  librsvg,
  lomiri-api,
  persistent-cache-cpp,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  shared-mime-info,
  taglib,
  validatePkgConfig,
  wrapGAppsHook3,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-thumbnailer";
  version = "3.0.5";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-thumbnailer";
    tag = finalAttrs.version;
    hash = "sha256-TfBGcHg9y9G2Rxs/OpZ8CcQrhK05gijZjVxOYSTkJJ8=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # In aarch64 lomiri-gallery-app VM tests, default 10s timeout for thumbnail extractor is often too tight
    # Raise to 20s to work around this (too much more will run into D-Bus' call timeout)
    ./2001-Raise-default-extraction-timeout.patch
  ];

  postPatch = ''
    patchShebangs tools/{parse-settings.py,run-xvfb.sh} tests/{headers,whitespace,server}/*.py

    substituteInPlace tests/thumbnailer-admin/thumbnailer-admin_test.cpp \
      --replace-fail '/usr/bin/test' 'test'

    substituteInPlace plugins/*/Thumbnailer*/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # I think this variable fails to be populated because of our toolchain, while upstream uses Debian / Ubuntu where this works fine
    # https://cmake.org/cmake/help/v3.26/variable/CMAKE_LIBRARY_ARCHITECTURE.html
    # > If the <LANG> compiler passes to the linker an architecture-specific system library search directory such as
    # > <prefix>/lib/<arch> this variable contains the <arch> name if/as detected by CMake.
    substituteInPlace tests/qml/CMakeLists.txt \
      --replace-fail 'CMAKE_LIBRARY_ARCHITECTURE' 'CMAKE_SYSTEM_PROCESSOR' \
      --replace-fail 'powerpc-linux-gnu' 'ppc' \
      --replace-fail 's390x-linux-gnu' 's390x'

    # Tests run in parallel to other builds, don't suck up cores
    substituteInPlace tests/headers/compile_headers.py \
      --replace-fail 'max_workers=multiprocessing.cpu_count()' "max_workers=1"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    gdk-pixbuf # setup hook
    pkg-config
    (python3.withPackages (
      ps:
      with ps;
      lib.optionals finalAttrs.finalPackage.doCheck [
        python-dbusmock
        tornado
      ]
    ))
    validatePkgConfig
    wrapGAppsHook3
  ];

  buildInputs = [
    boost
    cmake-extras
    gdk-pixbuf
    libapparmor
    libexif
    librsvg
    lomiri-api
    persistent-cache-cpp
    qtbase
    qtdeclarative
    shared-mime-info
    taglib
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    # Something seems borked with bad's h264 decoder, add libav as a workaround
    # https://github.com/NixOS/nixpkgs/issues/399599#issuecomment-2816268226
    gst-libav
    # maybe add ugly to cover all kinds of formats?
  ]);

  nativeCheckInputs = [
    shared-mime-info
    xvfb-run
  ];

  checkInputs = [
    gtest
    libqtdbustest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    # error: use of old-style cast to 'std::remove_reference<_GstElement*>::type' {aka 'struct _GstElement*'}
    (lib.cmakeBool "Werror" false)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # QSignalSpy tests in QML suite always fail, pass when running interactively
        "-E"
        "^qml"
      ]
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  preCheck = ''
    # Fontconfig warnings breaks some tests
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ ]; }}
    export HOME=$TMPDIR

    # Some tests need Qt plugins
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}

    # QML tests need QML modules
    export QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : ${lib.makeSearchPath "share" [ shared-mime-info ]}
    )
  '';

  passthru = {
    tests = {
      # gallery app delegates to thumbnailer, tests various formats
      inherit (nixosTests.lomiri-gallery-app)
        format-mp4
        format-gif
        format-bmp
        format-jpg
        format-png
        ;

      # music app relies on thumbnailer to extract embedded cover art
      music-app = nixosTests.lomiri-music-app;

      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "D-Bus service for out of process thumbnailing";
    mainProgram = "lomiri-thumbnailer-admin";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "liblomiri-thumbnailer-qt"
    ];
  };
})
