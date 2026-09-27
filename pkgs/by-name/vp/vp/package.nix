{
  lib,
  pkg-config,
  SDL2,
  SDL2_image,
  libx11,
  autoreconfHook,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vp";
  version = "1.8-unstable-2026-07-20";

  src = fetchFromGitHub {
    owner = "erikg";
    repo = "vp";
    rev = "56d14ed3c410ed1b5833f71d7cc6d305b73fac8b";
    hash = "sha256-7Pjs4h58gKPzXVOE8f4cCg84kmYBeyyGI1zTQlQU12U=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    libx11
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  # gcc15 build failure
  env.NIX_CFLAGS_COMPILE = toString [ "-std=gnu17" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/erikg/vp";
    description = "SDL based picture viewer/slideshow";
    license = lib.licenses.gpl3Plus;
    mainProgram = "vp";
    maintainers = [ ];
    inherit (SDL2.meta) platforms;
    hydraPlatforms = lib.platforms.linux; # build hangs on both Darwin platforms, needs investigation
  };
})
