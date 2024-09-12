{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_ttf,
  ffmpeg,
}:

stdenv.mkDerivation rec {
  pname = "video-compare";
  version = "20240818";

  src = fetchFromGitHub {
    owner = "pixop";
    repo = "video-compare";
    rev = version;
    hash = "sha256-577ql9v94NhBMHmG4QIuftrRK0FmRrjnvyuXmPGEZTI=";
  };

  buildInputs = [
    SDL2
    SDL2_ttf
    ffmpeg
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  installPhase = ''
    install -Dt $out/bin video-compare
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/pixop/video-compare";
    description = "Split screen video comparison tool";
    maintainers = with maintainers; [ orivej ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
