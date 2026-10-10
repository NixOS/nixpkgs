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

stdenv.mkDerivation (finalAttrs: {
  pname = "waylogout";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "loserMcloser";
    repo = "waylogout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h8Ip0Lxe2IGvuye2EvVyBH0hVoaOYlfDEv5ruSTq2h0=";
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "waylogout";
  };
})
