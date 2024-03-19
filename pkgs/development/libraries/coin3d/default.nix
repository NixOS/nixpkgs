{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, libGL
, libGLU
, libX11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coin";
  version = "unstable-2022-07-27";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    rev = "4c67945a58d2a6e5adb4d2332ab08007769130ef";
    hash = "sha256-lXS7GxtoPsZe2SJfr0uY99Q0ZtYG0KFlauY1PBuFleo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libGL
    libGLU
    libX11
  ];

  cmakeFlags = [ "-DCOIN_USE_CPACK=OFF" ];

  meta = with lib; {
    homepage = "https://github.com/coin3d/coin";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    mainProgram = "coin-config";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner viric ];
    platforms = platforms.linux;
  };
})
