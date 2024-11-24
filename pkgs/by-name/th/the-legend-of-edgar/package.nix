{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, gettext
, libpng
, pkg-config
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "the-legend-of-edgar";
  version = "1.36-unstable-2023-07-11";

  src = fetchFromGitHub {
    owner = "riksweeney";
    repo = "edgar";
    rev = "8344b385b65e8226455c7e88bd5aca57caa3c520";
    hash = "sha256-dOLKMsyQkVZ7gBiURfr/tFbu3xSqei8A/M2HSZgAFnI=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libpng
    zlib
  ];

  dontConfigure = true;

  makefile = "makefile";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BIN_DIR=${placeholder "out"}/bin/"
  ];

  hardeningDisable = [
    "fortify"
  ];

  meta = {
    homepage = "https://www.parallelrealities.co.uk/games/edgar";
    description = "2D platform game with a persistent world";
    longDescription = ''
      When Edgar's father fails to return home after venturing out one dark and
      stormy night, Edgar fears the worst: he has been captured by the evil
      sorcerer who lives in a fortress beyond the forbidden swamp.

      Donning his armour, Edgar sets off to rescue him, but his quest will not
      be easy...

      The Legend of Edgar is a platform game, not unlike those found on the
      Amiga and SNES. Edgar must battle his way across the world, solving
      puzzles and defeating powerful enemies to achieve his quest.
    '';
    license = lib.licenses.gpl1Plus;
    mainProgram = "edgar";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
