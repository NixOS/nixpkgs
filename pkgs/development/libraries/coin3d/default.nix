{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, libGL
, libGLU
, libX11
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "coin";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    rev = "v${version}";
    hash = "sha256-r4dN+uoFEndRa/NFs6wYUhMcUN07CaTja6sNPaOnCIY=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner viric ];
    platforms = platforms.linux;
  };
})
