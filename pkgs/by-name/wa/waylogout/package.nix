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
  version = "0.3";

  src = fetchFromGitHub {
    owner = "loserMcloser";
    repo = "waylogout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dsuuTjmZm3IpqXU68LsAz86HNbMFvKhWPYOMG/5Z4jE=";
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
