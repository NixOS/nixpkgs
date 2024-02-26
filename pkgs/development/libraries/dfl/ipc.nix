{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, qttools
, qtbase
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfl-ipc";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "ipc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dz9ilrA/w+LR7cG7JBykC6n32s00kPoUayQtXuTkdss=";
  };

  nativeBuildInputs = [
    meson
    ninja
    qttools
  ];

  buildInputs = [
    qtbase
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  dontWrapQtApps = true;

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/ipc";
    description = "A very simple set of IPC classes for inter-process communication.";
    maintainers = with lib.maintainers; [ sreehax ];
    license = lib.licenses.gpl3Only;
  };
})
