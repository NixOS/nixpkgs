{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  libepoxy,
  wayland,
  wayland-scanner,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wdisplays";
  version = "1.3.0";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    wayland-scanner
  ];

  buildInputs = [
    gtk3
    libepoxy
    wayland
  ];

  src = fetchFromGitHub {
    owner = "artizirk";
    repo = "wdisplays";
    rev = finalAttrs.version;
    sha256 = "sha256-y8tE3R0kGWVSqPFcT8EX2PBIwpdnyAaxICyXJ4J9NCA=";
  };

  meta = {
    description = "Graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/artizirk/wdisplays";
    maintainers = with lib.maintainers; [ ma27 ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "wdisplays";
  };
})
