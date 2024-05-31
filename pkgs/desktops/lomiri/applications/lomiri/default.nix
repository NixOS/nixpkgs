{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, fetchpatch2
, gitUpdater
, linkFarm
, nixosTests
, ayatana-indicator-datetime
, bash
, biometryd
, boost
, cmake
, cmake-extras
, coreutils
, dbus
, dbus-test-runner
, deviceinfo
, geonames
, glib
, glm
, gnome-desktop
, gsettings-qt
, gtk3
, hfd-service
, libevdev
, libqtdbustest
, libqtdbusmock
, libusermetrics
, libuuid
, lightdm_qt
, lomiri-api
, lomiri-app-launch
, lomiri-download-manager
, lomiri-indicator-network
, lomiri-ui-toolkit
, lomiri-settings-components
, lomiri-system-settings-unwrapped
, lomiri-schemas
, lomiri-notifications
, lomiri-thumbnailer
, maliit-keyboard
, mir
, nixos-icons
, pam
, pkg-config
, properties-cpp
, protobuf
, python3
, qmenumodel
, qtbase
, qtdeclarative
, qtmir
, qtmultimedia
, qtsvg
, telephony-service
, wrapGAppsHook3
, wrapQtAppsHook
, xwayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri";
    rev = finalAttrs.version;
    hash = "sha256-V5Lt870eHgmJ63OF8bTiNFLAFrxdgNihkd7aodSO3v8=";
  };

  patches = [
    # Remove when version > 0.2.1
    (fetchpatch {
      name = "0001-lomiri-Fix-overwriting-INCLUDE_DIRECTORIES-variable.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri/-/commit/53190bf2f03c8a35491efb26222b8d67ff6caa34.patch";
      hash = "sha256-sbwqOqpTf5OlEB4NZZZTFNXyKq4rTQAxJ6U8YP/DT5s=";
    })

    # fetchpatch2 for renames
    # Use GNUInstallDirs variables better, replace more /usr references
    # Remove when https://gitlab.com/ubports/development/core/lomiri/-/merge_requests/137 merged & in release
    (fetchpatch2 {
      name = "0002-lomiri-Make-less-FHS-assumptions.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri/-/commit/817ae1d8ed927e661fbc006851163ba99c46ae13.patch";
      hash = "sha256-NLvpzI2MtjKcGrgTn6PbLXSy3/Jg8KxdSvVYO9KYu9g=";
    })

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
      url = "https://salsa.debian.org/ubports-team/lomiri/-/raw/ebbe0f3f568bd145bb58a2e47f7112442328a0a5/debian/patches/1008_lomiri-greeter-wayland.patch";
      excludes = [ "data/lomiri-greeter.desktop.in.in" ]; # conflict with GNUInstallDirs patch
      hash = "sha256-XSSxf06Su8PMoqYwqevN034b/li8G/cNXjrqOXyhTRg=";
    })
    (fetchpatch {
      name = "1003-lomiri-Hide-launcher-in-greeter-mode.patch";
      url = "https://salsa.debian.org/ubports-team/lomiri/-/raw/ebbe0f3f568bd145bb58a2e47f7112442328a0a5/debian/patches/0002_qml-shell-hide-and-disallow-launcher-in-greeter-only-mode.patch";
      hash = "sha256-R0aMlb7N7XACCthML4SQSd0LvbadADfdQJqrYFhmujk=";
    })
    (fetchpatch {
      name = "1004-lomiri-Dont-reset-OSK-setting.patch";
      url = "https://salsa.debian.org/ubports-team/lomiri/-/raw/ebbe0f3f568bd145bb58a2e47f7112442328a0a5/debian/patches/2005_dont-reset-alwaysShowOsk-to-system-defaults-on-login.patch";
      hash = "sha256-guq/Ykcq4WcuXxNKO1eA4sJFyGSpZo0gtyFTdeK/GeE=";
    })

    ./9901-lomiri-Disable-Wizard.patch
    ./9902-lomiri-Check-NIXOS_XKB_LAYOUTS.patch
  ];

  postPatch = ''
    # Part of greeter fix, applies separately due to merge conflicts
    substituteInPlace data/lomiri-greeter.desktop.in.in \
      --replace-fail '@CMAKE_INSTALL_FULL_BINDIR@/lomiri-greeter-wrapper @CMAKE_INSTALL_FULL_BINDIR@/lomiri --mode=greeter' '@CMAKE_INSTALL_FULL_BINDIR@/lomiri --mode=greeter' \
      --replace-fail 'X-LightDM-Session-Type=mir' 'X-LightDM-Session-Type=wayland'

    # Need to replace prefix
    substituteInPlace data/systemd-user/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USERUNITDIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USERUNITDIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'

    # Don't embed full paths into regular desktop files (but do embed them into lightdm greeter one)
    substituteInPlace data/{indicators-client,lomiri}.desktop.in.in \
      --replace-fail '@CMAKE_INSTALL_FULL_BINDIR@/' ""

    # Exclude tests that don't compile (Mir headers these relied on were removed in mir 2.9)
    # fatal error: mirtest/mir/test/doubles/stub_surface.h: No such file or directory
    substituteInPlace tests/mocks/CMakeLists.txt \
      --replace-fail 'add_subdirectory(QtMir/Application)' ""

    #substituteInPlace plugins/AccountsService/CMakeLists.txt \
    #  --replace-fail 'CMAKE_INSTALL_DATADIR' 'CMAKE_INSTALL_FULL_DATADIR'

    # NixOS-ify

    # Use Nix flake instead of Canonical's Ubuntu logo
    rm qml/Launcher/graphics/home.svg
    ln -s ${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg qml/Launcher/graphics/home.svg

    # Look up default wallpaper in current system
    substituteInPlace plugins/Utils/constants.cpp \
      --replace-fail '/usr/share/backgrounds' '/run/current-system/sw/share/wallpapers'
  '' + lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/whitespace/check_whitespace.py
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # populates GSETTINGS_SCHEMAS_PATH
    pkg-config
    wrapGAppsHook3 # XDG_DATA_DIRS wrapper flags for schemas
    wrapQtAppsHook
  ];

  buildInputs = [
    ayatana-indicator-datetime
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
    lomiri-indicator-network
    lomiri-schemas
    lomiri-system-settings-unwrapped
    lomiri-ui-toolkit
    maliit-keyboard
    mir
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
    lomiri-thumbnailer
    qtmultimedia
    # telephony-service # currently broken: https://github.com/NixOS/nixpkgs/pull/314043
  ];

  nativeCheckInputs = [
    (python3.withPackages (ps: with ps; [
      python-dbusmock
    ]))
  ];

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
      --prefix PATH : ${lib.makeBinPath [ coreutils dbus deviceinfo glib ]} \
      --set LOMIRI_BINARY "$out/bin/lomiri"

    wrapProgram $out/libexec/Xwayland.lomiri \
      --prefix PATH : ${lib.makeBinPath [ deviceinfo ]}

    wrapProgram $out/libexec/lomiri-systemd-wrapper \
      --prefix PATH : ${lib.makeBinPath [ dbus ]}
  '';

  passthru = {
    tests.lomiri = nixosTests.lomiri;
    updateScript = gitUpdater { };
    greeter = linkFarm "lomiri-greeter" [{
      path = "${finalAttrs.finalPackage}/share/lightdm/greeters/lomiri-greeter.desktop";
      name = "lomiri-greeter.desktop";
    }];
  };

  meta = with lib; {
    description = "Shell of the Lomiri Operating environment";
    longDescription = ''
      Shell of the Lomiri Operating environment optimized for touch based human-machine interaction, but also supporting
      convergence (i.e. switching between tablet/phone and desktop mode).

      Lomiri is the user shell driving Ubuntu Touch based mobile devices.
    '';
    homepage = "https://lomiri.com/";
    changelog = "https://gitlab.com/ubports/development/core/lomiri/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    mainProgram = "lomiri";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
