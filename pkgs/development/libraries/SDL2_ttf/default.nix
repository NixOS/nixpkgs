{ stdenv, fetchurl, SDL2, freetype }:

stdenv.mkDerivation rec {
  name = "SDL2_ttf-2.0.14";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/${name}.tar.gz";
    sha256 = "0xljwcpvd2knrjdfag5b257xqayplz55mqlszrqp0kpnphh5xnrl";
  };

  buildInputs = [SDL2 freetype];

  postInstall = "ln -s $out/include/SDL2/SDL_ttf.h $out/include/";

  meta = {
    description = "SDL TrueType library";
  };
}
