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

  # src/zatackax.c:2069:5: error: conflicting types for 'SDL_main'
  # Fix SDL_main redefinition issue on darwin
  patches = lib.optional stdenv.hostPlatform.isDarwin ./0001-Fix-SDL_main-redefinition-issue-on-macOS.patch;

  # malloc.h is not needed because stdlib.h is already included.
  # On darwin, malloc.h does not even exist, resulting in an error.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/zatackax.h \
      --replace-fail '#include <malloc.h>' ""
  '';

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
    platforms = with lib.platforms; linux ++ darwin;
  };
})
