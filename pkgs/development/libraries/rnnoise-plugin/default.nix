{ lib, stdenv, SDL2, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "rnnoise-plugin";
  version = "0.91";

  src = fetchFromGitHub {
    owner = "werman";
    repo = "noise-suppression-for-voice";
    rev = "v${version}";
    sha256 = "11pwisbcks7g0mdgcrrv49v3ci1l6m26bbb7f67xz4pr1hai5dwc";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = with lib; {
    description = "A real-time noise suppression plugin for voice based on Xiph's RNNoise";
    homepage = "https://github.com/werman/noise-suppression-for-voice";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ panaeon henrikolsson ];
  };
}
