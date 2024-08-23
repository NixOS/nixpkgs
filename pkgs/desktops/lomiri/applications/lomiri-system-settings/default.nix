{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  accountsservice,
  ayatana-indicator-datetime,
  biometryd,
  cmake,
  cmake-extras,
  content-hub,
  dbus,
  deviceinfo,
  geonames,
  gettext,
  glib,
  gnome-desktop,
  gsettings-qt,
  gtk3,
  icu,
  intltool,
  json-glib,
  libqofono,
  libqtdbustest,
  libqtdbusmock,
  lomiri-indicator-network,
  lomiri-schemas,
  lomiri-settings-components,
  lomiri-ui-toolkit,
  maliit-keyboard,
  pkg-config,
  polkit,
  python3,
  qmenumodel,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  trust-store,
  ubports-click,
  upower,
  validatePkgConfig,
  wrapGAppsHook3,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-system-settings-unwrapped";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-system-settings";
    rev = finalAttrs.version;
    hash = "sha256-dWaXPr9Z5jz5SbwLSd3jVqjK0E5BdcKVeF15p8j47uM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [ ./2000-Support-wrapping-for-Nixpkgs.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}" \

    # Port from lomiri-keyboard to maliit-keyboard
    substituteInPlace plugins/language/CMakeLists.txt \
      --replace-fail 'LOMIRI_KEYBOARD_PLUGIN_PATH=\"''${CMAKE_INSTALL_FULL_LIBDIR}/lomiri-keyboard/plugins\"' 'LOMIRI_KEYBOARD_PLUGIN_PATH=\"${lib.getLib maliit-keyboard}/lib/maliit/keyboard2/languages\"'
    substituteInPlace plugins/language/{PageComponent,SpellChecking,ThemeValues}.qml plugins/language/onscreenkeyboard-plugin.cpp plugins/sound/PageComponent.qml \
      --replace-fail 'com.lomiri.keyboard.maliit' 'org.maliit.keyboard.maliit'

    # Gets list of available localisations from current system, but later drops any language that doesn't cover LSS
    # So just give it its own prefix
    substituteInPlace plugins/language/language-plugin.cpp \
      --replace-fail '/usr/share/locale' '${placeholder "out"}/share/locale'

    # Decide which entries should be visible based on the current system
    substituteInPlace plugins/*/*.settings \
      --replace-warn '/etc' '/run/current-system/sw/etc'

    # Don't use absolute paths in desktop file
    substituteInPlace lomiri-system-settings.desktop.in.in \
      --replace-fail 'Icon=@SETTINGS_SHARE_DIR@/system-settings.svg' 'Icon=lomiri-system-settings' \
      --replace-fail 'X-Lomiri-Splash-Image=@SETTINGS_SHARE_DIR@/system-settings-app-splash.svg' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/lomiri-system-settings.svg' \
      --replace-fail 'X-Screenshot=@SETTINGS_SHARE_DIR@/screenshot.png' 'X-Screenshot=lomiri-app-launch/screenshot/lomiri-system-settings.png'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    glib # glib-compile-schemas
    intltool
    pkg-config
    qtdeclarative
    validatePkgConfig
  ];

  buildInputs = [
    accountsservice
    cmake-extras
    deviceinfo
    geonames
    gnome-desktop
    gsettings-qt
    gtk3
    icu
    json-glib
    polkit
    qtbase
    trust-store
    ubports-click
    upower
  ];

  # QML components and schemas the wrapper needs
  propagatedBuildInputs = [
    ayatana-indicator-datetime
    biometryd
    content-hub
    libqofono
    lomiri-indicator-network
    lomiri-schemas
    lomiri-settings-components
    lomiri-ui-toolkit
    maliit-keyboard
    qmenumodel
    qtdeclarative
    qtmultimedia
  ];

  nativeCheckInputs = [
    dbus
    (python3.withPackages (ps: with ps; [ python-dbusmock ]))
    xvfb-run
  ];

  checkInputs = [
    libqtdbustest
    libqtdbusmock
  ];

  # Not wrapping in this derivation
  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LIBDEVICEINFO" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Hits OpenGL context issue inside lomiri-ui-toolkit, see derivation of that on details
            "^testmouse"
            "^tst_notifications"
          ]
        })")
      ]
    ))
  ];

  # The linking for this normally ignores missing symbols, which is inconvenient for figuring out why subpages may be
  # failing to load their library modules. Force it to report them at linktime instead of runtime.
  env.NIX_LDFLAGS = "--unresolved-symbols=report-all";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Parallelism breaks D-Bus tests
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${
      lib.makeSearchPathOutput "bin" qtbase.qtQmlPrefix (
        [
          qtdeclarative
          lomiri-ui-toolkit
          lomiri-settings-components
        ]
        ++ lomiri-ui-toolkit.propagatedBuildInputs
      )
    }
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas

    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/{splash,screenshot}}

    ln -s $out/share/lomiri-system-settings/system-settings.svg $out/share/icons/hicolor/scalable/apps/lomiri-system-settings.svg
    ln -s $out/share/lomiri-system-settings/system-settings-app-splash.svg $out/share/lomiri-app-launch/splash/lomiri-system-settings.svg
    ln -s $out/share/lomiri-system-settings/screenshot.png $out/share/lomiri-app-launch/screenshot/lomiri-system-settings.png
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "System Settings application for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-system-settings";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    mainProgram = "lomiri-system-settings";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [ "LomiriSystemSettings" ];
  };
})
