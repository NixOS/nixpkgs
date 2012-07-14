{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "SDL_net";
  version = "1.2.7";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_net/release/${name}.tar.gz";
    sha256 = "2ce7c84e62ff8117b9f205758bcce68ea603e08bc9d6936ded343735b8b77c53";
  };

  propagatedBuildInputs = [SDL];

  postInstall = ''
    sed -i -e 's,"SDL.h",<SDL/SDL.h>,' \
    -e 's,"SDL_endian.h",<SDL/SDL_endian.h>,' \
    -e 's,"SDL_version.h",<SDL/SDL_version.h>,' \
    -e 's,"begin_code.h",<SDL/begin_code.h>,' \
    -e 's,"close_code.h",<SDL/close_code.h>,' \
      $out/include/SDL/SDL_net.h

    ln -sv $out/include/SDL/SDL_net.h $out/include/
  '';

  meta = {
    description = "SDL networking library";
  };
}
