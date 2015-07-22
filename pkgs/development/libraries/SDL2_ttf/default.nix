{ stdenv, fetchurl, SDL2, freetype }:

stdenv.mkDerivation rec {
  name = "SDL2_ttf-2.0.12";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/${name}.tar.gz";
    sha256 = "0vkg6lyj278mdpd52map3rfi65fbq16w67ahmmfcl77a8da60a47";
  };

  buildInputs = [SDL2 freetype];

  postInstall = "ln -s $out/include/SDL2/SDL_ttf.h $out/include/";

  meta = {
    description = "SDL TrueType library";
  };
}
