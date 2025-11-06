{
  autoreconfHook,
  fetchFromGitHub,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,
  stdenv,
  lib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zatackax";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "simenheg";
    repo = "zatackax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1m99hi0kjpj5Yl1nAmwSMMdQWcP0rfLLPFJPkU4oVbM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    SDL_mixer
    SDL_ttf
    SDL_image
    SDL
  ];

  configureFlags = [ "CFLAGS=-I${lib.getDev SDL}/include/SDL" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source remake of the early computer game \"Achtung, die Kurve!\"";
    homepage = "https://github.com/simenheg/zatackax";
    changelog = "https://github.com/simenheg/zatackax/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.alch-emi ];
    mainProgram = "zatackax";
    platforms = lib.platforms.linux;
  };
})
