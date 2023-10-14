{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, testers
, boost
, cmake
, cmake-extras
, dbus
, dbus-cpp
, gtest
, libapparmor
, libelf
, pkg-config
, process-cpp
, properties-cpp
, qtbase
, qtdeclarative
, sqlite
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "biometryd";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/biometryd";
    rev = finalAttrs.version;
    hash = "sha256-b095rsQnd63Ziqe+rn3ROo4LGXZxZ3Sa6h3apzCuyCs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace '/etc' "\''${CMAKE_INSTALL_SYSCONFDIR}" \
      --replace '/lib' "\''${CMAKE_INSTALL_LIBDIR}"

    substituteInPlace data/biometryd.{conf,service} \
      --replace '/usr/bin' "$out/bin"

    substituteInPlace src/biometry/qml/Biometryd/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  '' + lib.optionalString (!finalAttrs.doCheck) ''
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
  ];

  buildInputs = [
    boost
    cmake-extras
    dbus
    dbus-cpp
    libapparmor
    libelf
    process-cpp
    properties-cpp
    qtbase
    qtdeclarative
    sqlite
  ];

  checkInputs = [
    gtest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DENABLE_WERROR=OFF"
    "-DWITH_HYBRIS=OFF"
  ];

  preBuild = ''
    # Generating plugins.qmltypes (also used in checkPhase?)
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "Mediates/multiplexes access to biometric devices";
    longDescription = ''
      biometryd mediates and multiplexes access to biometric devices present
      on the system, enabling applications and system components to leverage
      them for identification and verification of users.
    '';
    homepage = "https://gitlab.com/ubports/development/core/biometryd";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    mainProgram = "biometryd";
    platforms = platforms.linux;
    pkgConfigModules = [
      "biometryd"
    ];
  };
})
