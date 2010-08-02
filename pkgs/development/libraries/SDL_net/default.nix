{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "SDL_net";
  version = "1.2.7";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_net/release/${name}.tar.gz";
    sha256 = "2ce7c84e62ff8117b9f205758bcce68ea603e08bc9d6936ded343735b8b77c53";
  };

  buildInputs = [SDL];

  postInstall = "ln -s $out/include/SDL/SDL_net.h $out/include/";

  meta = {
    description = "SDL networking library";
  };
}
