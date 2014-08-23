{ stdenv, fetchurl, SDL, freetype }:

stdenv.mkDerivation {
  name = "SDL_ttf-2.0.11";

  src = fetchurl {
    url = http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz;
    sha256 = "1dydxd4f5kb1288i5n5568kdk2q7f8mqjr7i7sd33nplxjaxhk3j";
  };

  buildInputs = [SDL freetype];

  postInstall = "ln -s $out/include/SDL/SDL_ttf.h $out/include/";

  meta = {
    description = "SDL TrueType library";
  };
}
