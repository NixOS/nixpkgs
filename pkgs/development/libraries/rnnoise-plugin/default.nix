{ stdenv, SDL2, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "rnnoise-plugin";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "werman";
    repo = "noise-suppression-for-voice";
    rev = "v${version}";
    sha256 = "18bq5b50xw3d4r1ildinafpg3isb9y216430h4mm9wr3ir7h76a7";
  };

  buildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = with stdenv.lib; {
    description = "A real-time noise suppression plugin for voice based on Xiph's RNNoise";
    homepage = "https://github.com/werman/noise-suppression-for-voice";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ panaeon ];
  };
}
