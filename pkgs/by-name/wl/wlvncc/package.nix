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
  version = "0-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wlvncc";
    rev = "cc0abf87c37920540f2439a556e6a480c28f8f46";
    hash = "sha256-VPZJd4/yerWZeLl+NVH1EDtSokeS/XMS6lQUXOn9a7Q=";
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
