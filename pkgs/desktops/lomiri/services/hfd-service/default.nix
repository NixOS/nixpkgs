{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  accountsservice,
  cmake,
  cmake-extras,
  deviceinfo,
  libgbinder,
  libglibutil,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtfeedback,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hfd-service";
  version = "0.2.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/hfd-service";
    rev = finalAttrs.version;
    hash = "sha256-OpT1vNjnyq66v54EoGOZOUb4HECD4WRJRh9hYMB0GI0=";
  };

  postPatch = ''
    substituteInPlace qt/feedback-plugin/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/plugins" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtPluginPrefix}"

    # Queries pkg-config via pkg_get_variable, can't override prefix
    substituteInPlace init/CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_SYSTEM_DIR systemd systemdsystemunitdir)' 'set(SYSTEMD_SYSTEM_DIR ''${CMAKE_INSTALL_PREFIX}/lib/systemd/system)'
    substituteInPlace CMakeLists.txt \
      --replace 'pkg_get_variable(AS_INTERFACES_DIR accountsservice interfacesdir)' 'set(AS_INTERFACES_DIR "''${CMAKE_INSTALL_FULL_DATADIR}/accountsservice/interfaces")' \
      --replace '../../dbus-1/interfaces' "\''${CMAKE_INSTALL_PREFIX}/\''${DBUS_INTERFACES_DIR}" \
      --replace 'DESTINATION ''${DBUS_INTERFACES_DIR}' 'DESTINATION ''${CMAKE_INSTALL_PREFIX}/''${DBUS_INTERFACES_DIR}'
    substituteInPlace src/CMakeLists.txt \
      --replace "\''${DBUS_INTERFACES_DIR}/org.freedesktop.Accounts.xml" '${accountsservice}/share/dbus-1/interfaces/org.freedesktop.Accounts.xml'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    accountsservice
    cmake-extras
    deviceinfo
    libgbinder
    libglibutil
    qtbase
    qtdeclarative
    qtfeedback
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LIBHYBRIS" false)
  ];

  dontWrapQtApps = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "DBus-activated service that manages human feedback devices such as LEDs and vibrators on mobile devices";
    homepage = "https://gitlab.com/ubports/development/core/hfd-service";
    changelog = "https://gitlab.com/ubports/development/core/hfd-service/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
