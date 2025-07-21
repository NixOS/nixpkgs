{
  fetchFromGitLab,
  lib,
  libxkbcommon,
  meson,
  ninja,
  pixman,
  pkg-config,
  scdoc,
  stdenv,
  unstableGitUpdater,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_19,
  xwayland,
}:

stdenv.mkDerivation {
  pname = "wayback";
  version = "0-unstable-2025-07-20";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayback";
    repo = "wayback";
    rev = "4b1b4c59f67a2639e960d6b19e1282cf03fc3660";
    hash = "sha256-+4fPMVVPoUAYbt0jgfl+dmt0ZNyGGWF7xuF1UzZ2uiU=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots_0_19
    xwayland
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "X11 compatibility layer leveraging wlroots and Xwayland";
    homepage = "https://wayback.freedesktop.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "wayback-session";
    maintainers = with lib.maintainers; [ dramforever ];
  };
}
