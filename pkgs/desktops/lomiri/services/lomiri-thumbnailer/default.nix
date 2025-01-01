{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
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
  version = "3.0.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-thumbnailer";
    rev = finalAttrs.version;
    hash = "sha256-BE/U4CT4z4WzEJXrVhX8ME/x9q7w8wNnJKTbfVku2VQ=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/merge_requests/19 merged & in release
    (fetchpatch {
      name = "0001-lomiri-thumbnailer-Add-more-better-GNUInstallDirs-variables-usage.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/commit/0b9795a6313fd025d5646f2628a2cbb3104b0ebc.patch";
      hash = "sha256-br99n2nDLjUfnjbjhOsWlvP62VmVjYeZ6yPs1dhPN/s=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/merge_requests/22 merged & in release
    (fetchpatch {
      name = "0002-lomiri-thumbnailer-Make-tests-optional.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/commit/df7a3d1689f875d207a90067b957e888160491b9.patch";
      hash = "sha256-gVxigpSL/3fXNdJBjh8Ex3/TYmQUiwRji/NmLW/uhE4=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/merge_requests/23 merged & in release
    (fetchpatch {
      name = "0003-lomiri-thumbnailer-doc-liblomiri-thumbnailer-qt-Honour-CMAKE_INSTALL_DOCDIR.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/commit/930a3b57e899f6eb65a96d096edaea6a6f6b242a.patch";
      hash = "sha256-klYycUoQqA+Dfk/4fRQgdS4/G4o0sC1k98mbtl0iHkE=";
    })
    (fetchpatch {
      name = "0004-lomiri-thumbnailer-Re-enable-documentation.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/commit/2f9186f71fdd25e8a0852073f1da59ba6169cf3f.patch";
      hash = "sha256-youaJfCeYVpLmruHMupuUdl0c/bSDPWqKPLgu5plBrw=";
    })
    (fetchpatch {
      name = "0005-lomiri-thumbnailer-doc-liblomiri-thumbnailer-qt-examples-Drop-qt5_use_modules-usage.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/commit/9e5cf09de626e73e6b8f180cbc1160ebd2f169e7.patch";
      hash = "sha256-vfNCN7tqq6ngzNmb3qqHDHaDx/kI8/UXyyv7LqUWya0=";
    })
    (fetchpatch {
      name = "0006-lomiri-thumbnailer-Re-enable-coverge-reporting.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/commit/6a48831f042cd3ad34200f32800393d4eec2f84b.patch";
      hash = "sha256-HZd4K0R1W6adOjKy7tODfQAD+9IKPcK0DnH1uKNd/Ak=";
    })
    (fetchpatch {
      name = "0007-lomiri-thumbnailer-Make-GTest-available-to-example-test.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/commit/657be3bd1aeb227edc04e26b597b2fe97b2dc51a.patch";
      hash = "sha256-XEvdWV3JJujG16+87iewYor0jFK7NTeE5459iT96SkU=";
    })
    (fetchpatch {
      name = "0008-fix-googletest-1-13.patch";
      url = "https://salsa.debian.org/ubports-team/lomiri-thumbnailer/-/raw/debian/3.0.3-1/debian/patches/0001_fix_googletest_1_13.patch";
      hash = "sha256-oBcdspQMhCxh4L/XotG9NRp/Ij2YzIjpC8xg/jdiptw=";
    })
  ];

  postPatch = ''
    patchShebangs tools/{parse-settings.py,run-xvfb.sh} tests/{headers,whitespace,server}/*.py

    substituteInPlace tests/thumbnailer-admin/thumbnailer-admin_test.cpp \
      --replace '/usr/bin/test' 'test'

    substituteInPlace plugins/*/Thumbnailer*/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # I think this variable fails to be populated because of our toolchain, while upstream uses Debian / Ubuntu where this works fine
    # https://cmake.org/cmake/help/v3.26/variable/CMAKE_LIBRARY_ARCHITECTURE.html
    # > If the <LANG> compiler passes to the linker an architecture-specific system library search directory such as
    # > <prefix>/lib/<arch> this variable contains the <arch> name if/as detected by CMake.
    substituteInPlace tests/qml/CMakeLists.txt \
      --replace 'CMAKE_LIBRARY_ARCHITECTURE' 'CMAKE_SYSTEM_PROCESSOR' \
      --replace 'powerpc-linux-gnu' 'ppc' \
      --replace 's390x-linux-gnu' 's390x'

    # Tests run in parallel to other builds, don't suck up cores
    substituteInPlace tests/headers/compile_headers.py \
      --replace 'max_workers=multiprocessing.cpu_count()' "max_workers=1"
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

  buildInputs =
    [
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
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "D-Bus service for out of process thumbnailing";
    mainProgram = "lomiri-thumbnailer-admin";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-thumbnailer/-/blob/${finalAttrs.version}/ChangeLog";
    license = with licenses; [
      gpl3Only
      lgpl3Only
    ];
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "liblomiri-thumbnailer-qt"
    ];
  };
})
