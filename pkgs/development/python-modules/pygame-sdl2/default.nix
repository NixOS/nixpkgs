{
  buildPythonPackage,
  cython,
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
  version = "8.4.0.25071206";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "renpy";
    repo = "pygame_sdl2";
    tag = "renpy-${version}";
    hash = "sha256-I4zk19aNfVZstkVDLkwI/TBXliGAqVmOjeQLbRFri8Y=";
  };

  build-system = [
    cython
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

  postUnpack = ''
    substituteInPlace source/setup.py --replace-fail "2.1.0" "${version}"
    substituteInPlace source/src/pygame_sdl2/version.py --replace-fail "2, 1, 0" "${
      builtins.replaceStrings [ "." ] [ ", " ] version
    }"

    headers=$(mktemp -d)
    substituteInPlace source/setup.py --replace-fail \
      "pathlib.Path(sysconfig.get_paths()['include']) / \"pygame_sdl2\"" \
      "pathlib.Path(\"$headers\")"
  '';

  postInstall = ''
    install -Dm644 $headers/* -t $out/include/pygame_sdl2
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
