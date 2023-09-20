{ lib, stdenv, fetchurl
, pkg-config
, SDL2, libpng, libjpeg, libtiff, giflib, libwebp, libXpm, zlib, Foundation
, version ? "2.6.3"
, hash ? "sha256-kxyb5b8dfI+um33BV4KLfu6HTiPH8ktEun7/a0g2MSw="
}:

let
  pname = "SDL2_image";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/${pname}-${version}.tar.gz";
    inherit hash;
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
