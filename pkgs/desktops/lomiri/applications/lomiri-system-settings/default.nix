{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, accountsservice
, ayatana-indicator-datetime
, cmake
, cmake-extras
, content-hub
, dbus
, deviceinfo
, geonames
, gettext
, glib
, gnome-desktop
, gsettings-qt
, gtk3
, icu
, intltool
, json-glib
, libqofono
, libqtdbustest
, libqtdbusmock
, lomiri-indicator-network
, lomiri-schemas
, lomiri-settings-components
, lomiri-ui-toolkit
, maliit-keyboard
, pkg-config
, python3
, qmenumodel
, qtbase
, qtdeclarative
, qtmultimedia
, ubports-click
, upower
, validatePkgConfig
, wrapGAppsHook
, wrapQtAppsHook
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-system-settings-unwrapped";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-system-settings";
    rev = finalAttrs.version;
    hash = "sha256-gi6ZujIs0AEDLsqcTNlRNSS8SyqEU6q0+xaDf55XwuM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/lomiri-system-settings/-/merge_requests/433 merged & in release
    (fetchpatch {
      name = "0001-lomiri-system-settings-plugins-language-Fix-linking-against-accountsservice.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/commit/75763ae2f9669f5f7f29aec3566606e6f6cb7478.patch";
      hash = "sha256-2CE0yizkaz93kK82DhaaFjKmGnMoaikrwFj4k7RN534=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-system-settings/-/merge_requests/434 merged & in release
    (fetchpatch {
      name = "0002-lomiri-system-settings-GNUInstallDirs-and-fix-absolute-path-handling.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/commit/93ee84423f3677a608ef73addcd3ddcbe7dc1d32.patch";
      hash = "sha256-lSKAhtE3oSSv7USvDbbcfBZWAtWMmuKneWawKQABIiM=";
    })

    # Remove when version > 1.0.2
    (fetchpatch {
      name = "0003-lomiri-system-settings-Use-GSettings-for-DT2W-value.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/commit/29e2533efcac23e41b083b11c540c9221b71de7e.patch";
      hash = "sha256-d52d/b1ZdafaqhOljCg5E3I12XWtFAfG4rmn8CYngB4=";
    })
  ] ++ lib.optionals (lib.strings.versionOlder python3.pkgs.python-dbusmock.version "0.30.1") [
    # Makes tests work with newer dbusmock, but breaks with much-newer dbusmock
    # See for details:
    # - https://gitlab.com/ubports/development/core/lomiri-system-settings/-/merge_requests/354
    # - https://gitlab.com/ubports/development/core/lomiri-system-settings/-/merge_requests/426
    # Remove/adjust based on merges & next LSS release, and packaged version of dbusmock
    (fetchpatch {
      name = "0101-lomiri-system-settings-Pass-missing-parameters-to-dbusmock.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/commit/b9aacd88e3789dbb7578f32b31ad5b239db227a2.patch";
      hash = "sha256-jf+jMc+6QxONavlX5C9UZyX23jb6fZnYV8mWFyQGGbU=";
    })
    (fetchpatch {
      name = "0102-lomiri-system-settings-Fix-BT-plugin-testIsPaired.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/commit/e39b9728e18635413f07f9c9f6ddc73208260b2a.patch";
      hash = "sha256-YUtdlQ2XcanXzsxD40SbML7fSxG75yMKz/XnaQN9YP8=";
    })
    (fetchpatch {
      name = "0103-lomiri-system-settings-Fix-BT-plugin-testGet-IconName-Type.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/commit/9ad5d9324945f06f764d3a963dbfc7bccefe574b.patch";
      # Merge conflict, relevant change handled further down
      excludes = [ "CMakeLists.txt" ];
      hash = "sha256-QCgkVos9Q9/8jd25rqzdEKdnBw0Re47X7B9nLH8QOQU=";
    })
  ] ++ [

    ./2000-Support-wrapping-for-Nixpkgs.patch

    # Make it work with regular accountsservice
    # https://gitlab.com/ubports/development/core/lomiri-system-settings/-/issues/341
    (fetchpatch {
      name = "2001-lomiri-system-settings-disable-current-language-switching.patch";
      url = "https://sources.debian.org/data/main/l/lomiri-system-settings/1.0.1-2/debian/patches/2001_disable-current-language-switching.patch";
      hash = "sha256-ZOFYwxS8s6+qMFw8xDCBv3nLBOBm86m9d/VhbpOjamY=";
    })
  ];

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
    qtbase
    ubports-click
    upower
  ];

  # QML components and schemas the wrapper needs
  propagatedBuildInputs = [
    ayatana-indicator-datetime
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
    (python3.withPackages (ps: with ps; [
      python-dbusmock
    ]))
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
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (lib.concatStringsSep ";" [
      # Exclude tests
      "-E" (lib.strings.escapeShellArg "(${lib.concatStringsSep "|" [
        # Hits OpenGL context issue inside lomiri-ui-toolkit, see derivation of that on details
        "^testmouse"
        "^tst_notifications"
      ]})")
    ]))
  ];

  # CMake option had to be excluded from earlier patchset
  env.NIX_CFLAGS_COMPILE = lib.optionalString (lib.strings.versionOlder python3.pkgs.python-dbusmock.version "0.30.1") "-DMODERN_PYTHON_DBUSMOCK";

  # The linking for this normally ignores missing symbols, which is inconvenient for figuring out why subpages may be
  # failing to load their library modules. Force it to report them at linktime instead of runtime.
  env.NIX_LDFLAGS = "--unresolved-symbols=report-all";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Parallelism breaks D-Bus tests
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${lib.makeSearchPathOutput "bin" qtbase.qtQmlPrefix ([ qtdeclarative lomiri-ui-toolkit lomiri-settings-components ] ++ lomiri-ui-toolkit.propagatedBuildInputs)}
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
    pkgConfigModules = [
      "LomiriSystemSettings"
    ];
  };
})
