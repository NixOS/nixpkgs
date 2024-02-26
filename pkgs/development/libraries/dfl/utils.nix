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
  pname = "dfl-utils";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "utils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IxWYxQP9y51XbZAR+VOex/GYZblAWs8KmoaoFvU0rCY=";
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
    homepage = "https://gitlab.com/desktop-frameworks/utils";
    description = "Some utilities for DFL";
    maintainers = with lib.maintainers; [ sreehax ];
    license = lib.licenses.gpl3Only;
  };
})
