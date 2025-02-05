{
  buildPythonPackage,
  cython_0,
  fetchFromGitHub,
  lib,
  libjpeg,
  libpng,
  nix-update-script,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygame-sdl2";
  version = "8.3.1.24090601";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "renpy";
    repo = "pygame_sdl2";
    tag = "renpy-${version}";
    hash = "sha256-0itOmDScM+4HmWTpjkln56pv+yXDPB1KIDbE6ub2Tls=";
  };

  build-system = [
    cython_0
    SDL2
    setuptools
  ];

  dependencies = [
    libjpeg
    libpng
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  doCheck = true;

  preBuild = ''
    substituteInPlace setup.py --replace-fail "2.1.0" "${version}"
    substituteInPlace src/pygame_sdl2/version.py --replace-fail "2, 1, 0" "${
      builtins.replaceStrings [ "." ] [ ", " ] version
    }"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=renpy-(.*)" ]; };

  meta = {
    description = "Reimplementation of the Pygame API using SDL2 and related libraries";
    homepage = "https://github.com/renpy/pygame_sdl2";
    license = with lib.licenses; [
      lgpl2
      zlib
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
