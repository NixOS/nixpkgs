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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "wideriver";
    tag = finalAttrs.version;
    hash = "sha256-nDjK6BjRH4G+9ySTE4uV7SxaV8P3XKTgsFyDsx8Ld1U=";
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
