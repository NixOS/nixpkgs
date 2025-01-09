{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  cmake,
  dbus,
  libqtdbustest,
  lomiri-api,
  pkg-config,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-notifications";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-notifications";
    rev = finalAttrs.version;
    hash = "sha256-EGslfTgfADrmVGhNLG7HWqcDKhu52H/r41j7fxoliko=";
  };

  patches = [
    # Drop use of deprecated qt5_use_modules
    # Remove when https://gitlab.com/ubports/development/core/lomiri-notifications/-/merge_requests/11 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/lomiri-notifications/-/commit/5d164d6d8d68efe1d14154eca4d0d736ce2a1265.patch";
      hash = "sha256-nUg0zUft1n4AlotOaZgDqWbiVDvWvMizdlClavwygoI=";
    })
  ];

  postPatch =
    ''
      substituteInPlace CMakeLists.txt \
        --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

      # Need to replace prefix to not try to install into lomiri-api prefix
      substituteInPlace src/CMakeLists.txt \
        --replace '--variable=plugindir' '--define-variable=prefix=''${CMAKE_INSTALL_PREFIX} --variable=plugindir'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      sed -i CMakeLists.txt -e '/add_subdirectory(test)/d'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    lomiri-api
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
  ];

  checkInputs = [
    libqtdbustest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # In case anything still depends on deprecated hints
    "-DENABLE_UBUNTU_COMPAT=ON"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Deals with DBus
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Free Desktop Notification server QML implementation for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-notifications";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
