{ lib
, stdenv
, fetchFromGitHub
, aml
, cyrus_sasl
, ffmpeg
, gnutls
, libGL
, libdrm
, libgcrypt
, libjpeg
, libpng
, libxkbcommon
, lzo
, mesa
, meson
, ninja
, openssl
, pkg-config
, pixman
, wayland
, wayland-scanner
, zlib
}:
stdenv.mkDerivation {
  pname = "wlvncc";
  version = "unstable-2023-01-05";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wlvncc";
    rev = "2b9a886edd38204ef36e9f9f65dd32aaa3784530";
    hash = "sha256-0HbZEtDaLjr966RS+2GHc7N4nsivPIv57T/+AJliwUI=";
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
