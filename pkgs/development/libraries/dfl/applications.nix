{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, qttools
, qtbase
, dfl-ipc
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfl-applications";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "applications";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I6W37tThshlL79lmMipJqynXsfjFRw6WzLPPw0dvqH4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qttools
    cmake
  ];

  buildInputs = [
    dfl-ipc
    qtbase
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  dontWrapQtApps = true;

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/applications";
    description = "This library provides a thin wrapper around QApplication, QGuiApplication and QCoreApplication, to provide
single-instance functionality.";
    maintainers = with lib.maintainers; [ sreehax ];
    license = lib.licenses.gpl3Only;
  };
})
