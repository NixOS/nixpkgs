{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  SDL2,
}:

stdenv.mkDerivation {
  pname = "clunk";
  version = "1.0-unstable-2020-06-25";

  src = fetchFromGitHub {
    owner = "stalkerg";
    repo = "clunk";
    rev = "6d4cbbe1b6f1e202b9945d20073952b254e8d530";
    hash = "sha256-cz6v7rQYIoLf53Od7THmDPmBfhn8DBP7+uOIZRF0gc8=";
  };

  buildInputs = [ SDL2 ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Clunk - real-time binaural sound generation library. Versions for Vangers game. Porting to SDL2 and fix some errors";
    homepage = "https://github.com/stalkerg/clunk";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
  };

}
