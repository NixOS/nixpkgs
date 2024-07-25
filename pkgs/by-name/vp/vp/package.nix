{
  lib,
  SDL,
  SDL_image,
  autoreconfHook,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vp";
  version = "1.8-unstable-2017-03-22";

  src = fetchFromGitHub {
    owner = "erikg";
    repo = "vp";
    rev = "52bae15955dbd7270cc906af59bb0fe821a01f27";
    hash = "sha256-AWRJ//0z97EwvQ00qWDjVeZrPrKnRMOXn4RagdVrcFc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    SDL
  ];

  buildInputs = [
    SDL
    SDL_image
  ];

  outputs = [ "out" "man" ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL}/include/SDL"
    "-I${lib.getDev SDL_image}/include/SDL"
  ];

  meta = {
    homepage = "https://github.com/erikg/vp";
    description = "SDL based picture viewer/slideshow";
    license  = lib.licenses.gpl3Plus;
    mainProgram = "vp";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (SDL.meta) platforms;
  };
})
