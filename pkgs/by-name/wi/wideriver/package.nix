{
  stdenv,
  fetchFromGitHub,
  lib,
  wayland,
  wayland-scanner,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wideriver";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "wideriver";
    tag = finalAttrs.version;
    hash = "sha256-1D06onZiR8H4OuwNTr7NBnD1H7zagFHYlAXFo5CfibI=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Tiling window manager for the river wayland compositor, inspired by dwm and xmonad";
    homepage = "https://github.com/alex-courtis/wideriver";
    license = lib.licenses.gpl3Only;
    mainProgram = "wideriver";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ clebs ];
  };
})
