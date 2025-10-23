{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  setuptools-scm,
  packaging,
  aiohttp,
  requests,

  # native dependencies
  sdl3,
  sdl3-ttf,
  sdl3-image,
}:

let
  dochash =
    if stdenv.hostPlatform.isLinux then
      "sha256-d2YQUBWRlDROwiDMJ5mQAR9o+cYsbv1jiulsr1SAaik="
    else if stdenv.hostPlatform.isDarwin then
      "sha256-eIzTsn4wYz7TEyWN8QssM7fxpMfz/ENlxDVUMz0Cm4c="
    else if stdenv.hostPlatform.isWindows then
      "sha256-+iagR5jvpHi8WDh4/DO+GDP6jajEpZ6G1ROhM+zkSiw="
    else
      throw "PySDL3 does not support ${stdenv.hostPlatform.uname.system}";
  lib_ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
buildPythonPackage rec {
  pname = "pysdl3";
  version = "0.9.8b9";
  pyproject = true;

  pythonImportsCheck = [ "sdl3" ];

  src = fetchFromGitHub {
    owner = "Aermoss";
    repo = "PySDL3";
    tag = "v${version}";
    hash = "sha256-TpfMpp8CGb8lYALCWlMtyucxObDg1VYEvBW+mVHN9JM=";
  };

  docfile = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/${stdenv.hostPlatform.uname.system}-Docs.py";
    hash = "${dochash}";
  };

  postUnpack = ''
    cp ${docfile} source/sdl3/__doc__.py
  '';

  postInstall = ''
    mkdir $out/${python.sitePackages}/sdl3/bin
    ln -s ${sdl3}/lib/libSDL3${lib_ext} -t $out/${python.sitePackages}/sdl3/bin
    ln -s ${sdl3-ttf}/lib/libSDL3_ttf${lib_ext} -t $out/${python.sitePackages}/sdl3/bin
    ln -s ${sdl3-image}/lib/libSDL3_image${lib_ext} -t $out/${python.sitePackages}/sdl3/bin
  '';

  build-system = [
    setuptools-scm
  ];

  buildInputs = [
    sdl3
    sdl3-ttf
    sdl3-image
  ];

  dependencies = [
    packaging
    aiohttp
    requests
  ];

  # PySDL3 tries to update both itself and SDL binaries at runtime. This hook
  # sets some env variables to tell it not to do that.
  setupHook = ./setup-hook.sh;

  env = {
    SDL_VIDEODRIVER = "dummy";
    SDL_AUDIODRIVER = "dummy";
    SDL_RENDER_DRIVER = "software";
    PYTHONFAULTHANDLER = "1";
  };

  meta = {
    description = "Pure Python wrapper for SDL3";
    homepage = "https://github.com/Aermoss/PySDL3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jansol ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-windows"
      "x86_64-windows"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
