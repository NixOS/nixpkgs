{
  lib,
  stdenv,
  fetchFromGitHub,
  aml,
  cyrus_sasl,
  ffmpeg,
  gnutls,
  libGL,
  libdrm,
  libgcrypt,
  libjpeg,
  libpng,
  libxkbcommon,
  lzo,
  libgbm,
  meson,
  ninja,
  openssl,
  pkg-config,
  pixman,
  wayland,
  wayland-scanner,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "wlvncc";
  version = "0-unstable-2025-04-20";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wlvncc";
    rev = "a6a5463a9c69ce4db04d8d699dd58e1ba8560a0a";
    hash = "sha256-8p2IOQvcjOV5xe0c/RWP6aRHtQnu9tYI7QgcC13sg4k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    aml
    cyrus_sasl
    ffmpeg
    gnutls
    libGL
    libdrm
    libgcrypt
    libjpeg
    libpng
    libxkbcommon
    lzo
    libgbm
    openssl
    pixman
    wayland
    zlib
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wayland Native VNC Client";
    homepage = "https://github.com/any1/wlvncc";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ teutat3s ];
    platforms = lib.platforms.linux;
    mainProgram = "wlvncc";
  };
}
