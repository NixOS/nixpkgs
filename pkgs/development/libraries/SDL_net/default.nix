{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "SDL_net";
  version = "1.2.8";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_net/release/${name}.tar.gz";
    sha256 = "1d5c9xqlf4s1c01gzv6cxmg0r621pq9kfgxcg3197xw4p25pljjz";
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
