{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  qtbase,
  qtwayland,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayqt";
  version = "0.3.0-unstable-2026-03-03";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "wayqt";
    rev = "a7dfc9c682dce2721ddd84c17738619a95a23998";
    hash = "sha256-rC4Gdhr8mkL2V3bMWprMRo75AIhk9OJsoWjlBUnILEA=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    qtbase
    qtwayland
    wayland
  ];

  dontWrapQtApps = true;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/wayqt";
    description = "Qt-based library to handle Wayland and Wlroots protocols to be used with any Qt project";
    maintainers = with lib.maintainers; [ wineee ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
