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
  mesa,
  meson,
  ninja,
  openssl,
  pkg-config,
  pixman,
  wayland,
  wayland-scanner,
  zlib,
}:
stdenv.mkDerivation {
  pname = "wlvncc";
  version = "unstable-2024-11-23";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wlvncc";
    rev = "0489e29fba374a08be8ba4a64d492a3c74018f41";
    hash = "sha256-jFP4O6zo1fYULOVX9+nuTNAy4NuBKsDKOy+WUQRUjdI=";
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
    mesa
    openssl
    pixman
    wayland
    zlib
  ];

  meta = with lib; {
    description = "Wayland Native VNC Client";
    homepage = "https://github.com/any1/wlvncc";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ teutat3s ];
    platforms = platforms.linux;
    mainProgram = "wlvncc";
  };
}
