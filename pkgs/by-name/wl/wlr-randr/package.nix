{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "wlr-randr";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "wlr-randr";
    rev = "v${version}";
    hash = "sha256-lHOGpY0IVnR8QdSqJbtIA4FkhmQ/zDiFNqqXyj8iw/s=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [ wayland ];
  depsBuildBuild = [
    pkg-config
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Xrandr clone for wlroots compositors";
    homepage = "https://gitlab.freedesktop.org/emersion/wlr-randr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.linux;
    mainProgram = "wlr-randr";
  };
}
