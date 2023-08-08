{ lib, stdenv, fetchFromGitHub, freetype, SDL2, autoreconfHook, pango, pkg-config }:

stdenv.mkDerivation rec {
  pname = "SDL_Pango";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "markuskimius";
    repo = "SDL2_Pango";
    rev = "v${version}";
    hash = "sha256-8SL5ylxi87TuKreC8m2kxlLr8rcmwYYvwkp4vQZ9dkc=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ SDL2 pango freetype ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "A library for graphically rendering internationalized and tagged text in SDL2 using TrueType fonts";
    license = licenses.lgpl21;
    platforms = platforms.all;
    homepage = "https://github.com/markuskimius/SDL2_Pango";
    maintainers = with maintainers; [ rardiol ];
  };
}
