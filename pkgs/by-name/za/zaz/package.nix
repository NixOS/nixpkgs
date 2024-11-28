{ lib, stdenv
, fetchurl
, pkg-config
, SDL
, SDL_image
, mesa
, libtheora
, libvorbis
, libogg
, ftgl
, freetype
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zaz";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/zaz/zaz-${finalAttrs.version}.tar.gz";
    sha256 = "1r3bmwny05zzmdalxm5ah2rray0nnsg1w00r30p47q6x2lpwj8ml";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    (lib.getDev SDL)
    SDL_image
    mesa
    libtheora
    libvorbis.dev
    libogg
    ftgl
    freetype
  ];

  # Fix SDL include problems
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL}/include/SDL -I${SDL_image}/include/SDL";
  # Fix linking errors
  makeFlags = [
    "ZAZ_LIBS+=-lSDL"
    "ZAZ_LIBS+=-lvorbis"
    "ZAZ_LIBS+=-ltheora"
    "ZAZ_LIBS+=-logg"
    "ZAZ_LIBS+=-ltheoraenc"
    "ZAZ_LIBS+=-ltheoradec"
    "ZAZ_LIBS+=-lvorbisfile"
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Puzzle game about arranging balls in triplets, like Luxor, Zuma, or Puzzle Bobble";
    homepage = "https://zaz.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "zaz";
  };
})
