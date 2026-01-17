{
  stdenv,
  lib,
  fetchFromGitLab,
  replaceVars,
  meson,
  pkg-config,
  ninja,
  qtbase,
  qtwayland,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayqt";
  version = "0.3.0-unstable-2026-01-05";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "wayqt";
    rev = "2750cd93a3110bff6345f9e2a1a3090a3e3f7203";
    hash = "sha256-WGIZ3OgeGkQWEzc/m0/Moo9Qgr3vg4dFfQhba2vx0do=";
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
