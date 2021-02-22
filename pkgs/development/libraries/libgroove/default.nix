{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, ffmpeg_3, SDL2, chromaprint, libebur128 }:

stdenv.mkDerivation rec {
  version = "4.3.0";
  pname = "libgroove";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libgroove";
    rev = version;
    sha256 = "1la9d9kig50mc74bxvhx6hzqv0nrci9aqdm4k2j4q0s1nlfgxipd";
  };

  patches = [
    ./no-warnings-as-errors.patch
    (fetchpatch {
      name = "update-for-ffmpeg-3.0.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-update-for-ffmpeg-3.0.patch?h=libgroove&id=a9f3bd2a5afd3227733414a5d54c7a2aa0a1249e";
      sha256 = "0800drk9df1kwbv80f2ffv77xk888249fk0d961rp2a305hvyrk0";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ffmpeg_3 SDL2 chromaprint libebur128 ];

  meta = with lib; {
    description = "Streaming audio processing library";
    homepage = "https://github.com/andrewrk/libgroove";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andrewrk ];
  };
}
