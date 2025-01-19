{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  quazip,
  rlottie,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rlottie-qml";
  version = "0-unstable-2021-05-03";

  src = fetchFromGitLab {
    owner = "mymike00";
    repo = "rlottie-qml";
    rev = "f9506889a284039888c7a43db37e155bb7b30c40";
    hash = "sha256-e2/4e1GGFfJMwShy6qgnUVVRxjV4WfjQwcqs09RK194=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Remove when https://gitlab.com/mymike00/rlottie-qml/-/merge_requests/1 merged
    (fetchpatch {
      name = "0001-rlottie-qml-Use-upstream-QuaZip-config-module.patch";
      url = "https://gitlab.com/mymike00/rlottie-qml/-/commit/5656211dd8ae190795e343f47a3393fd3d8d25a4.patch";
      hash = "sha256-t2NlYVU+D8hKd+AvBWPEavAhJKlk7Q3y2iAQSYtks5k=";
    })
  ];

  postPatch = ''
    # Fix QML install path
    substituteInPlace CMakeLists.txt \
      --replace-fail 'QT_IMPORTS_DIR "/lib/''${ARCH_TRIPLET}"' 'QT_IMPORTS_DIR "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"' \
      --replace-fail "\''${QT_IMPORTS_DIR}/\''${PLUGIN}" "\''${QT_IMPORTS_DIR}" \
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    rlottie
    qtbase
    qtdeclarative
    qtmultimedia
  ];

  propagatedBuildInputs = [
    # Config module requires this
    quazip
  ];

  # Only a QML module
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Library for using rlottie via QML";
    homepage = "https://gitlab.com/mymike00/rlottie-qml";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
})
