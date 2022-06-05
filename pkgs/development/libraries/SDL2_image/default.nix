{ lib, stdenv, fetchurl
, pkg-config
, SDL2, libpng, libjpeg, libtiff, giflib, libwebp, libXpm, zlib, Foundation
}:

stdenv.mkDerivation rec {
  pname = "SDL2_image";
  version = "2.0.5";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/${pname}-${version}.tar.gz";
    sha256 = "1l0864kas9cwpp2d32yxl81g98lx40dhbdp03dz7sbv84vhgdmdx";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ SDL2 libpng libjpeg libtiff giflib libwebp libXpm zlib ]
    ++ lib.optional stdenv.isDarwin Foundation;

  configureFlags = [
    # Disable dynamically loaded dependencies
    "--disable-jpg-shared"
    "--disable-png-shared"
    "--disable-tif-shared"
    "--disable-webp-shared"
  ] ++ lib.optionals stdenv.isDarwin [
    # Darwin headless will hang when trying to run the SDL test program
    "--disable-sdltest"
    # Don't use native macOS frameworks
    "--disable-imageio"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "SDL image library";
    homepage = "http://www.libsdl.org/projects/SDL_image/";
    platforms = platforms.unix;
    license = licenses.zlib;
    maintainers = with maintainers; [ cpages ];
  };
}
