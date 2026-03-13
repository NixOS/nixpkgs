{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  accounts-qt,
  cmake,
  cmake-extras,
  gettext,
  gtest,
  libnotify,
  lomiri-api,
  lomiri-indicator-network,
  lomiri-online-accounts,
  lomiri-url-dispatcher,
  pkg-config,
  qtbase,
  qtpim,
  signond,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-sync-monitor";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-sync-monitor";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-E/WrDnUztcetXcRy8SNeojXsKLeUBa9cOpglc2FHmk8=";
  };

  patches = [
    # Remove when version > 0.6.0
    (fetchpatch {
      name = "0001-lomiri-sync-monitor-Install-to-LIBEXECDIR.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/commit/c9f22718bd5dde0ee73549612f07b969785928ba.patch";
      hash = "sha256-0twVIBU5CeHeqYj7rn1j2SHfl1jxsFmQudb7mTq1skU=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/merge_requests/70 merged & in release
    (fetchpatch {
      name = "1001-lomiri-sync-monitor-Drop-qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/commit/0d7d74fa0bfdea54a20fb012945abfb73a64f42b.patch";
      hash = "sha256-nOG0VJFO17jdtHTW8FdECtTjawRSFGf8CL2/8tRkI9s=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/merge_requests/71 merged & in release
    (fetchpatch {
      name = "1002-lomiri-sync-monitor-Fix-GNUInstallDirs-usage.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/commit/ea3579bf0b575e308b9d4313454cd81d90256681.patch";
      hash = "sha256-jI6cAD/MJ9PtHO0kCGjnLfcoZhd+LuYzaMA7O8jL/t0=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/merge_requests/72 merged & in release
    (fetchpatch {
      name = "1003-lomiri-sync-monitor-Use-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/commit/d4ed22c593f29bc0b59b2722e23a47b1042358d0.patch";
      hash = "sha256-Jl57PREzByx3EDF6lq/n7d6muDuHN7EKw8mPlOqd6K0=";
    })
  ];

  postPatch = ''
    substituteInPlace Lomiri/SyncMonitor/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    substituteInPlace CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SERVICE_FILE_BASE_DIR accounts-qt5 servicefilesdir)' 'pkg_get_variable(SERVICE_FILE_BASE_DIR accounts-qt5 servicefilesdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail 'pkg_get_variable(PROVIDER_FILE_BASE_DIR accounts-qt5 providerfilesdir)' 'pkg_get_variable(PROVIDER_FILE_BASE_DIR accounts-qt5 providerfilesdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail 'pkg_get_variable(PLUGIN_QML_DIR LomiriOnlineAccountsPlugin plugin_qml_dir)' 'pkg_get_variable(PLUGIN_QML_DIR LomiriOnlineAccountsPlugin plugin_qml_dir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'

    substituteInPlace systemd/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    accounts-qt
    cmake-extras
    libnotify
    lomiri-api # lomiri-indicator-network
    lomiri-indicator-network
    lomiri-online-accounts
    lomiri-url-dispatcher
    qtbase
    qtpim
    signond
  ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Flaky, QSignalSpy doesn't catch signal properly
            "^eds-helper-test"
          ]
        })")
      ]
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Manages syncing Evolution calendars on a schedule";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-sync-monitor";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-sync-monitor/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      bsd3
      gpl3Only
      lgpl21Plus
    ];
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
