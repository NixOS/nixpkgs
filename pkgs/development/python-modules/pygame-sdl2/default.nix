{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  renpy,
  cython_0,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  libjpeg,
  libpng,
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

  nativeBuildInputs = [
    SDL2.dev
    cython_0
    setuptools
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer
    libjpeg
    libpng
  ];

  doCheck = true;

  preBuild = ''
    sed -i "s/2.1.0/${version}/" setup.py
    sed -i "s/2, 1, 0/$(echo ${version} | sed 's/\./,\ /g')/g" src/pygame_sdl2/version.py
  '';

  meta = {
    description = "Reimplementation of parts of pygame API using SDL2";
    homepage = "https://github.com/renpy/pygame_sdl2";
    license = with lib.licenses; [
      lgpl2
      zlib
    ];
    maintainers = with lib.maintainers; [ raskin ];
  };
}
