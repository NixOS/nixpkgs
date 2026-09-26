{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  bash,
  cmake,
  dbus,
  deviceinfo,
  glib,
  inotify-tools,
  lomiri,
  lomiri-schemas,
  makeWrapper,
  pkg-config,
  systemd,
  wrapGAppsHook4,
  xdg-user-dirs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-session";
  version = "0.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-session";
    rev = finalAttrs.version;
    hash = "sha256-zEH1VNBgOs9xP18toBc2VqMloDM6uL+tSIIEKZTHY0c=";
  };

  patches = [ ./1001-Unset-QT_QPA_PLATFORMTHEME.patch ];

  postPatch = ''
    substituteInPlace lomiri-session.in \
      --replace-fail '/usr/libexec/Xwayland.lomiri' '${lib.getBin lomiri}/libexec/Xwayland.lomiri'

    substituteInPlace systemd/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'

    # Inject a call to xdg-user-dirs-update, so when mediascanner2 launches, it can actually scan for files
    substituteInPlace desktop/dm-lomiri-session.in \
      --replace-fail '@CMAKE_INSTALL_FULL_LIBEXECDIR@/lomiri-session/run-systemd-session' '${lib.getExe' xdg-user-dirs "xdg-user-dirs-update"} && @CMAKE_INSTALL_FULL_LIBEXECDIR@/lomiri-session/run-systemd-session'
  '';

  # Checks for run-time tools at configure-time
  strictDeps = false;

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    glib # hook for wrapper arguments
    makeWrapper
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    bash
    deviceinfo
    dbus
    inotify-tools
    lomiri
    lomiri-schemas # for hook to pick up schemas
    systemd
  ];

  dontWrapGApps = true;

  cmakeFlags = [
    # Requires lomiri-system-compositor -> not ported to Mir 2.x yet
    (lib.cmakeBool "ENABLE_TOUCH_SESSION" false)
  ];

  postInstall = ''
    patchShebangs $out/bin/lomiri-session
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          deviceinfo # device-info
          glib # gsettings
          inotify-tools
          lomiri
          systemd # systemd-detect-virt
        ]
      }
    )
  '';

  postFixup = ''
    wrapGApp $out/bin/lomiri-session
  '';

  passthru = {
    providedSessions = [
      "lomiri"
      # not packaged/working yet
      # "lomiri-touch"
    ];
    tests = nixosTests.lomiri;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Integrates Lomiri desktop/touch sessions into display / session managers";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-session";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-session/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-session";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
