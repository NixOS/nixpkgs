{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  linkFarm,
  replaceVars,
  nixosTests,
  bash,
  biometryd,
  boost,
  cmake,
  cmake-extras,
  coreutils,
  dbus,
  dbus-test-runner,
  deviceinfo,
  geonames,
  glib,
  glm,
  gnome-desktop,
  gsettings-qt,
  gtk3,
  hfd-service,
  libevdev,
  libqtdbustest,
  libqtdbusmock,
  libusermetrics,
  libuuid,
  lightdm_qt,
  lomiri-api,
  lomiri-app-launch,
  lomiri-download-manager,
  lomiri-indicator-datetime,
  lomiri-indicator-network,
  lomiri-notifications,
  lomiri-settings-components,
  lomiri-system-settings-unwrapped,
  lomiri-schemas,
  lomiri-telephony-service,
  lomiri-thumbnailer,
  lomiri-ui-toolkit,
  maliit-keyboard,
  mir_2_15,
  nixos-icons,
  pam,
  pkg-config,
  properties-cpp,
  protobuf,
  python3,
  qmenumodel,
  qtbase,
  qtdeclarative,
  qtmir,
  qtmultimedia,
  qtsvg,
  wrapGAppsHook3,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri";
    tag = finalAttrs.version;
    hash = "sha256-5fwSLUTntVyV5FIVnPishrU/55tyTyx0Fzh6oitaWwo=";
  };

  patches = [
    # Fix greeter & related settings
    # These patches are seemingly not submitted upstream yet
    (fetchpatch {
      name = "1000-lomiri-QT_IM_MODULE-maliit.patch";
      url = "https://salsa.debian.org/ubports-team/lomiri/-/raw/ebbe0f3f568bd145bb58a2e47f7112442328a0a5/debian/patches/2003_maliit-not-maliitphablet-as-im-module-namespace.patch";
      hash = "sha256-5HEMl0x1S9Hb7spxPRgu8OBebmpaLa6zko2uVEYtBmY=";
    })
    (fetchpatch {
      name = "1001-lomiri-QT_QPA_PLATFORM-wayland.patch";
      url = "https://salsa.debian.org/ubports-team/lomiri/-/raw/ebbe0f3f568bd145bb58a2e47f7112442328a0a5/debian/patches/2004_qt-qpa-platform-is-wayland.patch";
      hash = "sha256-4C6X2TW+yjZhqYPIcQ3GJeTKbz785i7p/DpT+vX1DSQ=";
    })
    (fetchpatch {
      name = "1002-lomiri-Fix-Lomiri-greeter.patch";
      url = "https://salsa.debian.org/ubports-team/lomiri/-/raw/5f9d28fe6f0ba9ab7eed149b4da7f6b3f4eae55a/debian/patches/1008_lomiri-greeter-wayland.patch";
      hash = "sha256-vuNTKWA50krtx/+XB2pMI271q57N+kqWlfq54gtf/HI=";
    })
    (fetchpatch {
      name = "1004-lomiri-Dont-reset-OSK-setting.patch";
      url = "https://salsa.debian.org/ubports-team/lomiri/-/raw/ebbe0f3f568bd145bb58a2e47f7112442328a0a5/debian/patches/2005_dont-reset-alwaysShowOsk-to-system-defaults-on-login.patch";
      hash = "sha256-guq/Ykcq4WcuXxNKO1eA4sJFyGSpZo0gtyFTdeK/GeE=";
    })

    ./9901-lomiri-Disable-Wizard.patch
    (replaceVars ./9902-Layout-fallback-file.patch {
      nixosLayoutFile = "/etc/" + finalAttrs.finalPackage.passthru.etcLayoutsFile;
    })
  ];

  postPatch =
    ''
      # Written with a different qtmir branch in mind, but different branch breaks compat with some patches
      substituteInPlace CMakeLists.txt \
        --replace-fail 'qt5mir2server' 'qtmirserver'

      # Need to replace prefix
      substituteInPlace data/systemd-user/CMakeLists.txt \
        --replace-fail 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemd_user_unit_dir)' 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemd_user_unit_dir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'

      # Don't embed full paths into regular desktop files (but do embed them into lightdm greeter one)
      substituteInPlace data/{indicators-client,lomiri}.desktop.in.in \
        --replace-fail '@CMAKE_INSTALL_FULL_BINDIR@/' ""

      # Exclude tests that don't compile (Mir headers these relied on were removed in mir 2.9)
      # fatal error: mirtest/mir/test/doubles/stub_surface.h: No such file or directory
      substituteInPlace tests/mocks/CMakeLists.txt \
        --replace-fail 'add_subdirectory(QtMir/Application)' ""

      # This needs to launch the *lomiri* indicators, now that datetime is split into lomiri and non-lomiri variants
      substituteInPlace data/lomiri-greeter-wrapper \
        --replace-fail 'ayatana-indicators.target' 'lomiri-indicators.target'

      # NixOS-ify

      # Use Nix flake instead of Canonical's Ubuntu logo
      rm qml/Launcher/graphics/home.svg
      ln -s ${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg qml/Launcher/graphics/home.svg

      # Look up default wallpaper in current system
      substituteInPlace plugins/Utils/constants.cpp \
        --replace-fail '/usr/share/backgrounds' '/run/current-system/sw/share/wallpapers'
    ''
    + lib.optionalString finalAttrs.finalPackage.doCheck ''
      patchShebangs tests/whitespace/check_whitespace.py
    '';

  nativeBuildInputs = [
    cmake
    dbus-test-runner
    glib # populates GSETTINGS_SCHEMAS_PATH
    pkg-config
    wrapGAppsHook3 # XDG_DATA_DIRS wrapper flags for schemas
    wrapQtAppsHook
  ];

  buildInputs = [
    bash
    boost
    cmake-extras
    dbus
    dbus-test-runner
    deviceinfo
    geonames
    glib
    glm
    gnome-desktop
    gsettings-qt
    gtk3
    libevdev
    libusermetrics
    libuuid
    lightdm_qt
    lomiri-api
    lomiri-app-launch
    lomiri-download-manager
    lomiri-indicator-datetime
    lomiri-indicator-network
    lomiri-schemas
    lomiri-system-settings-unwrapped
    lomiri-ui-toolkit
    maliit-keyboard
    mir_2_15
    pam
    properties-cpp
    protobuf
    qmenumodel
    qtbase
    qtdeclarative
    qtmir
    qtsvg

    # QML import path
    biometryd
    hfd-service
    lomiri-notifications
    lomiri-settings-components
    lomiri-telephony-service
    lomiri-thumbnailer
    qtmultimedia
  ];

  nativeCheckInputs = [ (python3.withPackages (ps: with ps; [ python-dbusmock ])) ];

  checkInputs = [
    libqtdbustest
    libqtdbusmock
  ];

  # Need its flags
  dontWrapGApps = true;

  # Manually calling, to avoid double & unnecessary wrapping
  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "NO_TESTS" (!finalAttrs.finalPackage.doCheck))
    (lib.cmakeBool "WITH_MIR2" true)
  ];

  postInstall = ''
    install -Dm755 ../data/lomiri-greeter-wrapper $out/bin/lomiri-greeter-wrapper
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export XDG_DATA_DIRS=${libqtdbusmock}/share
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapQtApp $out/bin/lomiri
    wrapQtApp $out/bin/indicators-client
    wrapQtApp $out/bin/lomiri-mock-indicator-service

    wrapProgram $out/bin/lomiri-greeter-wrapper \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          dbus
          deviceinfo
          glib
        ]
      } \
      --set LOMIRI_BINARY "$out/bin/lomiri"

    wrapProgram $out/libexec/Xwayland.lomiri \
      --prefix PATH : ${lib.makeBinPath [ deviceinfo ]}

    wrapProgram $out/libexec/lomiri-systemd-wrapper \
      --prefix PATH : ${lib.makeBinPath [ dbus ]}
  '';

  passthru = {
    etcLayoutsFile = "lomiri/keymaps";
    tests = nixosTests.lomiri;
    updateScript = gitUpdater { };
    greeter = linkFarm "lomiri-greeter" [
      {
        path = "${finalAttrs.finalPackage}/share/lightdm/greeters/lomiri-greeter.desktop";
        name = "lomiri-greeter.desktop";
      }
    ];
  };

  meta = {
    description = "Shell of the Lomiri Operating environment";
    longDescription = ''
      Shell of the Lomiri Operating environment optimized for touch based human-machine interaction, but also supporting
      convergence (i.e. switching between tablet/phone and desktop mode).

      Lomiri is the user shell driving Ubuntu Touch based mobile devices.
    '';
    homepage = "https://lomiri.com/";
    changelog = "https://gitlab.com/ubports/development/core/lomiri/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
