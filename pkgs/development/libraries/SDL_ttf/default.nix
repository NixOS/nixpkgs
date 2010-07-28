{ stdenv, fetchurl, SDL, freetype }:

stdenv.mkDerivation {
  name = "SDL_ttf-2.0.9";

  src = fetchurl {
    url = http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.9.tar.gz;
    sha256 = "0ls6anmlmwrmy21p3y9nfyl6fkwz4jpgh74kw7xd0hwbg5v8h95l";
  };

  buildInputs = [SDL freetype];

  postInstall = "ln -s $out/include/SDL/SDL_ttf.h $out/include/";

  meta = {
    description = "SDL TrueType library";
  };
}
