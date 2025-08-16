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
  version = "1.1.3";

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
    sha256 = "sha256-KabaW2BH4zAS0xWkzCM8YaAnP/hkZL7Wq3EARantRis=";
  };

  meta = with lib; {
    description = "Graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/artizirk/wdisplays";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "wdisplays";
  };
})
