{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "wlr-randr";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2kWTVAi4hq2d9jQ6yBLVzm3x7n/oSvBdZ45WyjhXhc4=";
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

  meta = {
    description = "Xrandr clone for wlroots compositors";
    homepage = "https://git.sr.ht/~emersion/wlr-randr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.linux;
    mainProgram = "wlr-randr";
  };
}
