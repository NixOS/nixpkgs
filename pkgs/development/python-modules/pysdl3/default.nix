{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  packaging,

  # native dependencies
  sdl3,
  sdl3-ttf,
  sdl3-image,
}:

let
  osname =
    if stdenv.hostPlatform.isLinux then
      "Linux"
    else if stdenv.hostPlatform.isDarwin then
      "Darwin"
    else if stdenv.hostPlatform.isWindows then
      "Windows"
    else
      "Unknown";
  dochash =
    if stdenv.hostPlatform.isLinux then
      "sha256-+1zLd308zL+m68kLMeOWWxT0wYDgCd6g9cc2hEtaeUs="
    else if stdenv.hostPlatform.isDarwin then
      "sha256-2uB9+ABgv5O376LyHb0ShGjM4LHYzMRMxk/k+1LBmv0="
    else if stdenv.hostPlatform.isWindows then
      "sha256-46bQSPYctycizf2GXichd5V74LjxwIAPhBmklXAJ/Jg="
    else
      "";
in
buildPythonPackage rec {
  pname = "pysdl3";
  version = "0.9.8b1";
  pyproject = true;

  pythonImportsCheck = [ "sdl3" ];

  src = fetchFromGitHub {
    owner = "Aermoss";
    repo = "PySDL3";
    rev = "v${version}";
    hash = "sha256-FVUCcqKTq6qdNkYHTYFiUxt2HIaNC5LK0BEUfz8Mue8=";
  };

  docfile = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/${osname}-Docs.py";
    hash = "${dochash}";
  };

  postUnpack = ''
    cp ${docfile} source/sdl3/__doc__.py
  '';

  patches = [
    ./no-network-requests.patch
  ];

  postPatch = ''
    NIXPKGS_SDL_PATHS='
      "${sdl3}/lib/libSDL3.so",
      "${sdl3-ttf}/lib/libSDL3_ttf.so",
      "${sdl3-image}/lib/libSDL3_image.so"
    '
    substituteInPlace sdl3/__init__.py --subst-var NIXPKGS_SDL_PATHS
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    sdl3
    sdl3-ttf
    sdl3-image
  ];

  dependencies = [
    packaging
  ];

  pythonRemoveDeps = [
    "requests"
    "aiohttp"
  ];

  env = {
    SDL_VIDEODRIVER = "dummy";
    SDL_AUDIODRIVER = "dummy";
    SDL_RENDER_DRIVER = "software";
    PYTHONFAULTHANDLER = "1";
  };

  meta = {
    changelog = "https://github.com/Aermoss/PySDL3/compare/v0.9.8b0..${src.rev}";
    description = "Pure Python wrapper for SDL3";
    homepage = "https://github.com/Aermoss/PySDL3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jansol ];
  };
}
