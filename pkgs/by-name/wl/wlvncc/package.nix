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
  version = "0-unstable-2025-07-07";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wlvncc";
    rev = "bc6063aeacd4fbe9ac8f58f4ba3c5388b3e1f1f2";
    hash = "sha256-Udu/CtrNBqnlgZCK2cS8VWNTfHJGXdijTnNIWnAW2Nw=";
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
