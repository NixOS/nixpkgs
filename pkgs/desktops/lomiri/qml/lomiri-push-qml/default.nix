{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, cmake
, lomiri-api
, lomiri-indicator-network
, pkg-config
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-push-qml";
  version = "0-unstable-2022-09-15";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-push-qml";
    rev = "6f87ee5cf92e2af0e0ce672835e71704e236b8c0";
    hash = "sha256-ezLcQRJ7Sq/TVbeGJL3Vq2lzBe7StRRCrWXZs2CCUX8=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/lomiri-push-qml/-/merge_requests/6 merged
    (fetchpatch {
      name = "0001-lomiri-push-qml-Stop-using-qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-push-qml/-/commit/a4268c98b9f50fdd52da69c173d377f78ea93104.patch";
      hash = "sha256-OijTB5+I9/wabT7dX+DkvoEROKzAUIKhBZkkhqq5Oig=";
    })
  ];

  postPatch = ''
    # Queries QMake for QML install location, returns QtBase build path
    substituteInPlace src/*/PushNotifications/CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}' \
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
  ];

  buildInputs = [
    lomiri-api
    lomiri-indicator-network
    qtbase
    qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # In case anything still depends on deprecated hints
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true)
  ];

  preBuild = ''
    # For qmlplugindump
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Lomiri Push Notifications QML plugin";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-push-qml";
    # License file indicates gpl3Only, but de87869c2cdb9819c2ca7c9eca9c5fb8b500a01f says it should be lgpl3Only
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
