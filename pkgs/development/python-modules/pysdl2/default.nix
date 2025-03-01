{
  stdenv,
  lib,
  replaceVars,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,

  # native dependencies
  SDL2,
  SDL2_ttf,
  SDL2_image,
  SDL2_gfx,
  SDL2_mixer,

  # tests
  numpy,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysdl2";
  version = "0.9.17";
  pyproject = true;

  pythonImportsCheck = [ "sdl2" ];

  src = fetchFromGitHub {
    owner = "py-sdl";
    repo = "py-sdl2";
    tag = version;
    hash = "sha256-FqVgDGpImLN2a51TnU6eKjLK3rwW3ujdzOkK58ERBbE=";
  };

  patches = [
    (replaceVars ./PySDL2-dll.patch (
      builtins.mapAttrs
        (_: pkg: "${pkg}/lib/lib${pkg.pname}${stdenv.hostPlatform.extensions.sharedLibrary}")
        {
          inherit
            SDL2
            SDL2_ttf
            SDL2_image
            SDL2_gfx
            SDL2_mixer
            ;
        }
    ))
  ];

  build-system = [ setuptools ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    SDL2_gfx
    SDL2_mixer
  ];

  env = {
    SDL_VIDEODRIVER = "dummy";
    SDL_AUDIODRIVER = "dummy";
    SDL_RENDER_DRIVER = "software";
    PYTHONFAULTHANDLER = "1";
  };

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # GetPrefPath for OrgName/AppName is None
    "test_SDL_GetPrefPath"
  ];

  meta = {
    changelog = "https://github.com/py-sdl/py-sdl2/releases/tag/${src.tag}";
    description = "Wrapper around the SDL2 library and as such similar to the discontinued PySDL project";
    homepage = "https://github.com/py-sdl/py-sdl2";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
}
