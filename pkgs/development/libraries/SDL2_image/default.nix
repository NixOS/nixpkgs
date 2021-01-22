{ lib, stdenv, fetchurl, SDL2, libpng, libjpeg, libtiff, libungif, libwebp, libXpm, zlib, Foundation }:

stdenv.mkDerivation rec {
  pname = "SDL2_image";
  version = "2.0.5";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/${pname}-${version}.tar.gz";
    sha256 = "1l0864kas9cwpp2d32yxl81g98lx40dhbdp03dz7sbv84vhgdmdx";
  };

  buildInputs = [ SDL2 libpng libjpeg libtiff libungif libwebp libXpm zlib ]
    ++ lib.optional stdenv.isDarwin Foundation;


  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "SDL image library";
    homepage = "http://www.libsdl.org/projects/SDL_image/";
    platforms = platforms.unix;
    license = licenses.zlib;
    maintainers = with maintainers; [ cpages ];
  };
}
