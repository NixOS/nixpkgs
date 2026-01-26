{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  replaceVars,
  testers,
  dbus-test-runner,
  dpkg,
  gdb,
  glib,
  lttng-ust,
  mesa,
  perl,
  pkg-config,
  python3,
  qmake,
  qtbase,
  qtdeclarative,
  qtfeedback,
  qtgraphicaleffects,
  qtpim,
  qtquickcontrols2,
  qtsvg,
  qtsystems,
  qttools,
  suru-icon-theme,
  validatePkgConfig,
  wrapQtAppsHook,
  xvfb-run,
}:

let
  listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
  qtPluginPaths = listToQtVar qtbase.qtPluginPrefix [
    qtbase
    qtpim
    qtsvg
  ];
  qtQmlPaths = listToQtVar qtbase.qtQmlPrefix [
    qtdeclarative
    qtfeedback
    qtgraphicaleffects
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-ui-toolkit";
  version = "1.3.5902";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-ui-toolkit";
    rev = finalAttrs.version;
    hash = "sha256-sNOWDx7pyYuO+Pi7YsPRbT1ChU/EhfHBuGW92H3EEKI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    ./2001-Mark-problematic-tests.patch

    (replaceVars ./2002-Nixpkgs-versioned-QML-path.patch.in {
      qtVersion = lib.versions.major qtbase.version;
    })
  ];

  postPatch = ''
    patchShebangs documentation/docs.sh tests/

    for subproject in po app-launch-profiler lomiri-ui-toolkit-launcher; do
      substituteInPlace $subproject/$subproject.pro \
        --replace-fail "\''$\''$[QT_INSTALL_PREFIX]" "$out" \
        --replace-warn "\''$\''$[QT_INSTALL_LIBS]" "$out/lib"
    done

    # Install apicheck tool into bin
    substituteInPlace apicheck/apicheck.pro \
      --replace-fail "\''$\''$[QT_INSTALL_LIBS]/lomiri-ui-toolkit" "$out/bin"

    substituteInPlace documentation/documentation.pro \
      --replace-fail '/usr/share/doc' '$$PREFIX/share/doc' \
      --replace-fail '$$[QT_INSTALL_DOCS]' '$$PREFIX/share/doc/lomiri-ui-toolkit'

    # Causes redefinition error with our own fortify hardening
    sed -i '/DEFINES += _FORTIFY_SOURCE/d' features/lomiri_common.prf

    # Reverse dependencies (and their reverse dependencies too) access the function patched here to register their gettext catalogues,
    # so hardcoding any prefix here will make only catalogues in that prefix work. APP_DIR envvar will override this, but with domains from multiple derivations being
    # used in a single application (lomiri-system-settings), that's of not much use either.
    # https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/blob/dcb3a523c56a400e5c3c163c2836cafca168767e/src/LomiriToolkit/i18n.cpp#L101-129
    #
    # This could be solved with a reference to the prefix of whoever requests the domain, but the call happens via some automatic Qt / QML callback magic,
    # I'm not sure what the best way of injecting that there would be.
    # https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/blob/dcb3a523c56a400e5c3c163c2836cafca168767e/src/LomiriToolkit/i18n_p.h#L34
    #
    # Using /run/current-system/sw/share/locale instead of /usr/share/locale isn't a great
    # solution, but at least it should get us working localisations
    substituteInPlace src/LomiriToolkit/i18n.cpp \
      --replace-fail "/usr" "/run/current-system/sw"

    # The code here overrides the regular QML import variables so the just-built modules are found & used in the tests
    # But we need their QML dependencies too, so put them back in there
    substituteInPlace export_qml_dir.sh \
      --replace-fail '_IMPORT_PATH=$BUILD_DIR/qml' '_IMPORT_PATH=$BUILD_DIR/qml:${qtQmlPaths}'

    # These tests try to load Suru theme icons, but override XDG_DATA_DIRS / use full paths to load them
    substituteInPlace \
      tests/unit/visual/tst_visual.cpp \
      tests/unit/visual/tst_icon.{11,13}.qml \
      tests/unit/visual/tst_imageprovider.11.qml \
      --replace-fail '/usr/share' '${suru-icon-theme}/share'
  '';

  # With strictDeps, QMake only picks up Qt dependencies from nativeBuildInputs
  strictDeps = false;

  nativeBuildInputs = [
    perl
    pkg-config
    python3
    qmake
    qttools # qdoc, qhelpgenerator
    validatePkgConfig
    wrapQtAppsHook
  ];

  buildInputs = [
    glib
    lttng-ust
    qtbase
    qtdeclarative
    qtpim
    qtquickcontrols2
    qtsystems
  ];

  propagatedBuildInputs = [
    qtfeedback
    qtgraphicaleffects
    qtsvg
  ];

  nativeCheckInputs = [
    dbus-test-runner
    dpkg # `dpkg-architecture -qDEB_HOST_ARCH` response decides how tests are run
    gdb
    mesa.llvmpipeHook # ShapeMaterial needs an OpenGL context: https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    xvfb-run
  ];

  qmakeFlags = [
    # Ubuntu UITK compatibility, for older / not-yet-migrated applications
    "CONFIG+=ubuntu-uitk-compat"
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Explicitly not parallel-safe, large parts are always run in series and at least qquick_image_extension fails with parallelism
  enableParallelChecking = false;

  checkPhase = ''
    runHook preCheck

    export HOME=$PWD

    # XDG_RUNTIME_DIR with wrong permissions causes warnings that are interpreted as errors in the test suite
    export XDG_RUNTIME_DIR=$PWD/runtime-dir
    mkdir -p $XDG_RUNTIME_DIR
    chmod -R 700 $XDG_RUNTIME_DIR

    # Tests need some Qt plugins
    # Many tests try to load Suru theme icons via XDG_DATA_DIRS
    export QT_PLUGIN_PATH=${qtPluginPaths}
    export XDG_DATA_DIRS=${suru-icon-theme}/share

    export UITK_BUILD_ROOT=$PWD

    tests/xvfb.sh make check ''${enableParallelChecking:+-j''${NIX_BUILD_CORES}}

    runHook postCheck
  '';

  preInstall = ''
    # wrapper script calls qmlplugindump, crashes due to lack of minimal platform plugin
    # Could not find the Qt platform plugin "minimal" in ""
    # Available platform plugins are: wayland-egl, wayland, wayland-xcomposite-egl, wayland-xcomposite-glx.
    export QT_PLUGIN_PATH=${qtPluginPaths}

    # Qt-generated wrapper script lacks QML paths to dependencies
    for qmlModule in Components PerformanceMetrics Test; do
      substituteInPlace src/imports/$qmlModule/wrapper.sh \
        --replace-fail 'QML2_IMPORT_PATH=' 'QML2_IMPORT_PATH=${qtQmlPaths}:'
    done
  '';

  postInstall = ''
    # Code loads Qt's qt_module.prf, which force-overrides all QMAKE_PKGCONFIG_* variables except PREFIX for QMake-generated pkg-config files
    for pcFile in Lomiri{Gestures,Metrics,Toolkit}.pc; do
      substituteInPlace $out/lib/pkgconfig/$pcFile \
        --replace-fail "${lib.getLib qtbase}/lib" "\''${prefix}/lib" \
        --replace-fail "${lib.getDev qtbase}/include" "\''${prefix}/include"
    done

    # These are all dev-related tools, but declaring a bin output also moves around the QML modules
    moveToOutput "bin" "$dev"
  '';

  postFixup = ''
    for qtBin in $dev/bin/{apicheck,lomiri-ui-toolkit-launcher}; do
      wrapQtApp $qtBin
    done
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "QML components to ease the creation of beautiful applications in QML";
    longDescription = ''
      This project consists of a set of QML components to ease the creation of beautiful applications in QML for Lomiri.

      QML alone lacks built-in components for basic widgets like Button, Slider, Scrollbar, etc, meaning a developer has
      to build them from scratch.
      This toolkit aims to stop this duplication of work, supplying beautiful components ready-made and with a clear and
      consistent API.

      These components are fully themeable so the look and feel can be easily customized. Resolution independence
      technology is built in so UIs are scaled to best suit the display.

      Other features:
        - localisation through gettext
    '';
    homepage = "https://gitlab.com/ubports/development/core/lomiri-ui-toolkit";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "LomiriGestures"
      "LomiriMetrics"
      "LomiriToolkit"
    ];
  };
})
