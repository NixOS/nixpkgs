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
      "sha256-ldx6r0KKNl1mkohTkaEG4rawf4VjHeJvNUdPkmrAkYA="
    else if stdenv.hostPlatform.isDarwin then
      "sha256-ga0ebb9zIPI5+Qza8APs0kbCxUIxqCmXRO/R8uWASOg="
    else if stdenv.hostPlatform.isWindows then
      "sha256-bBwETA9/ph0zXVNad9zMkQvfq1MmFJ08tCV+mUPwlXQ="
    else
      throw "PySDL3 does not support ${stdenv.hostPlatform.uname.system}";
  lib_ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
buildPythonPackage rec {
  pname = "pysdl3";
  version = "0.9.11b0";
  pyproject = true;

  pythonImportsCheck = [ "sdl3" ];

  src = fetchFromGitHub {
    owner = "Aermoss";
    repo = "PySDL3";
    tag = "v${version}";
    hash = "sha256-lUnQ5YDM6HXarZUSy+x95lStBXDQlvG5JL6hFdHg6z0=";
  };

  docfile = fetchurl {
    url = "https://github.com/Aermoss/PySDL3/releases/download/v${version}/${stdenv.hostPlatform.uname.system}-Docs.py";
    hash = dochash;
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

    # For import checks, duplicated from setup hook.
    SDL_CHECK_BINARY_VERSION = 0;
    SDL_DISABLE_METADATA = 1;
    # Checks for __doc__.py next to the file being executed.
    # It's very fragile, and doesn't work during the import check.
    SDL_DOC_GENERATOR = 0;
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
