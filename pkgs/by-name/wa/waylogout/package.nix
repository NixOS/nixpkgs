{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  cairo,
  gdk-pixbuf,
  scdoc,
}:

stdenv.mkDerivation {
  pname = "waylogout";
  version = "0.3-unstable-2025-07-30";

  src = fetchFromGitHub {
    owner = "loserMcloser";
    repo = "waylogout";
    rev = "e3ab4da6c7d883213b797153cd66d3dca8d3af62";
    hash = "sha256-VpDPsIq8Si203mOlY1qNcczsLcK5T9SGBkc+TvVbdXE=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    cairo
    gdk-pixbuf
  ];

  meta = {
    description = "Graphical logout/suspend/reboot/shutdown dialog for wayland";
    homepage = "https://github.com/loserMcloser/waylogout";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    platforms = lib.platforms.linux;
    mainProgram = "waylogout";
  };
}
