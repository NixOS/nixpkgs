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
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "wayqt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FPyHm96LYCTqMZlPrZoSPMeyocDjaCnaYJETH/nazBU=";
  };

  patches = [
    # qmake get qtbase's path, but wayqt need qtwayland
    (replaceVars ./fix-qtwayland-header-path.diff {
      qtWaylandPath = "${qtwayland}/include";
    })
  ];

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
