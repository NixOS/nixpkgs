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

buildPythonPackage (finalAttrs: {
  pname = "pysdl2";
  version = "0.9.17-unstable-2025-11-18";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "py-sdl";
    repo = "py-sdl2";
    rev = "3d0672135fab3ca58e2f00c0a76b7b25cb818784";
    hash = "sha256-SgorCWZmJk13LNlTmh5Aomik14PTZdWliU3GWtkTASE=";
  };

  patches = [
    (replaceVars ./PySDL2-dll.patch (
      (builtins.mapAttrs
        (_: pkg: "${pkg}/lib/lib${pkg.pname}${stdenv.hostPlatform.extensions.sharedLibrary}")
        {
          inherit
            SDL2_ttf
            SDL2_image
            SDL2_gfx
            SDL2_mixer
            ;
        }
      )
      // {
        # sdl2-compat has the pname sdl2-compat,
        # but the shared object is named libSDL2.so for compatibility reasons.
        # This requires making the shared object path for SDL2 not depend on pname.
        SDL2 = (pkg: "${pkg}/lib/libSDL2${stdenv.hostPlatform.extensions.sharedLibrary}") SDL2;
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

  pythonImportsCheck = [ "sdl2" ];

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # GetPrefPath for OrgName/AppName is None
    "test_SDL_GetPrefPath"

    # AssertionError:
    # clip: Could not set clip rect SDL_Rect(x=2, y=2, w=0, h=0)
    "test_SDL_GetSetClipRect"

    # AssertionError: That operation is not supported
    "test_SDL_GetSetWindowMouseRect"
  ];

  meta = {
    changelog = "https://github.com/py-sdl/py-sdl2/compare/0.9.17..${finalAttrs.src.rev}";
    description = "Wrapper around the SDL2 library and as such similar to the discontinued PySDL project";
    homepage = "https://github.com/py-sdl/py-sdl2";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
})
