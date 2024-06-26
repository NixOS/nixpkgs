{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libdrm,
  libva,
}:

stdenv.mkDerivation rec {
  pname = "cmrt";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "cmrt";
    rev = version;
    sha256 = "sha256-W6MQI41J9CKeM1eILCkvmW34cbCC8YeEF2mE+Ci8o7s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libdrm
    libva
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://01.org/linuxmedia";
    description = "Intel C for Media Runtime";
    longDescription = "Media GPU kernel manager for Intel G45 & HD Graphics family";
    license = licenses.mit;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux;
  };
}
