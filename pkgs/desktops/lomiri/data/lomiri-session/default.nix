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
  inotify-tools,
  lomiri,
  makeWrapper,
  pkg-config,
  runtimeShell,
  systemd,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-session";
  version = "0.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-session";
    rev = finalAttrs.version;
    hash = "sha256-XduE3tPUjw/wIjFCACasxtN33KO4bDLWrpl7pZcYaAA=";
  };

  patches = [ ./1001-Unset-QT_QPA_PLATFORMTHEME.patch ];

  postPatch = ''
    substituteInPlace lomiri-session.in \
      --replace-fail '/usr/libexec/Xwayland.lomiri' '${lib.getBin lomiri}/libexec/Xwayland.lomiri'

    substituteInPlace systemd/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    bash
    deviceinfo
    dbus
    inotify-tools
    lomiri
    systemd
  ];

  cmakeFlags = [
    # Requires lomiri-system-compositor -> not ported to Mir 2.x yet
    (lib.cmakeBool "ENABLE_TOUCH_SESSION" false)
  ];

  postInstall = ''
    patchShebangs $out/bin/lomiri-session
    wrapProgram $out/bin/lomiri-session \
      --prefix PATH : ${
        lib.makeBinPath [
          deviceinfo
          inotify-tools
          lomiri
        ]
      }
  '';

  passthru = {
    providedSessions = [
      "lomiri"
      # not packaged/working yet
      # "lomiri-touch"
    ];
    tests.lomiri = nixosTests.lomiri;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Integrates Lomiri desktop/touch sessions into display / session managers";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-session";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-session/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    mainProgram = "lomiri-session";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
