{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, withAnimation ? true
, withTranscoder ? true
}:

let
  cmakeBool = b: if b then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "draco";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = version;
    hash = "sha256-BoJg2lZBPVVm6Nc0XK8QSISpe+B8tpgRg9PFncN4+fY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [
    "-DDRACO_ANIMATION_ENCODING=${cmakeBool withAnimation}"
    "-DDRACO_TRANSCODER_SUPPORTED=${cmakeBool withTranscoder}"
    "-DBUILD_SHARED_LIBS=${cmakeBool true}"
  ];

  meta = with lib; {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.all;
  };
}
