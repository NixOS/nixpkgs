{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
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
    wayland-scanner
  ];
  buildInputs = [ wayland ];
  depsBuildBuild = [
    pkg-config
  ];

  meta = with lib; {
    description = "Xrandr clone for wlroots compositors";
    homepage = "https://gitlab.freedesktop.org/emersion/wlr-randr";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
    mainProgram = "wlr-randr";
  };
}
