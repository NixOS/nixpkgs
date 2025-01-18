{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  libjpeg,
  libpng,
  nix-update-script,
  python3,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
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
    python3.pkgs.cython_0
    python3.pkgs.setuptools
    python3.pkgs.wheel
    SDL2
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
    sed -i "s/2.1.0/${version}/" setup.py
    sed -i "s/2, 1, 0/$(echo ${version} | sed 's/\./,\ /g')/g" src/pygame_sdl2/version.py
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
