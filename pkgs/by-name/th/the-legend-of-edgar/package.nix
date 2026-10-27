{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  gettext,
  libpng,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "the-legend-of-edgar";
  version = "1.38";

  src = fetchFromGitHub {
    owner = "riksweeney";
    repo = "edgar";
    rev = finalAttrs.version;
    hash = "sha256-8Q2R6DrDb8ajWeewp10NlDYPPOu7HOl4LxO6DluitWQ=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gettext
    SDL2
  ];

  buildInputs = [
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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.parallelrealities.co.uk/games/edgar";
    changelog = "https://github.com/riksweeney/edgar/releases/tag/${finalAttrs.version}";
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
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.unix;
  };
})
