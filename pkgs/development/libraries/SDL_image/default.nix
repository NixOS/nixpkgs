{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  SDL,
  libpng,
  libjpeg,
  libtiff,
  giflib,
  libXpm,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "SDL_image";
  version = "1.2.12";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/${pname}-${version}.tar.gz";
    sha256 = "16an9slbb8ci7d89wakkmyfvp7c0cval8xw4hkg0842nhhlp540b";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-2887";
      url = "https://github.com/libsdl-org/SDL_image/commit/e7723676825cd2b2ffef3316ec1879d7726618f2.patch";
      includes = [ "IMG_xcf.c" ];
      sha256 = "174ka2r95i29nlshzgp6x5vc68v7pi8lhzf33and2b1ms49g4jb7";
    })
  ];

  configureFlags = [
    # Disable its dynamic loading or dlopen will fail because of no proper rpath
    "--disable-jpg-shared"
    "--disable-png-shared"
    "--disable-tif-shared"
  ] ++ lib.optional stdenv.isDarwin "--disable-sdltest";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL
    libpng
    libjpeg
    libtiff
    giflib
    libXpm
  ];

  meta = with lib; {
    description = "SDL image library";
    homepage = "http://www.libsdl.org/projects/SDL_image/";
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
