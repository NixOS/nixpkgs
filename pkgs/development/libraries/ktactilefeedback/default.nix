{
  stdenv,
  lib,
  fetchFromGitLab,
  unstableGitUpdater,
  cmake,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
  qtmultimedia,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktactilefeedback";
  version = "0-unstable-2025-07-25";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "jbbgameich";
    repo = "ktactilefeedback";
    rev = "da7858aaa125588d4c309f273afefff93222e8f9";
    hash = "sha256-VEGZkA6bWuKJK6fk4u6RB5aMV8fbabD8ymm8HC/ddzg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    extra-cmake-modules
    qtbase
    qtmultimedia
  ];

  # Library
  dontWrapQtApps = true;

  cmakeFlags = [
    # Need to run these post-install, so QML import path exists
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doInstallCheck)
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckTarget = "test";
  preInstallCheck = ''
    export QML2_IMPORT_PATH=$out/${qtbase.qtQmlPrefix}:${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Tactile feedback library for Qt";
    homepage = "https://invent.kde.org/jbbgameich/ktactilefeedback";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      OPNA2608
    ];
    platforms = lib.platforms.linux;
  };
})
