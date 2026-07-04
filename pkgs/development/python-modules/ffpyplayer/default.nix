{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,

  # build-system
  cython,
  setuptools,

  # buildInputs
  SDL2,
  # ffpyplayer is not compatible with ffmpeg 7
  # https://github.com/matham/ffpyplayer/issues/16
  ffmpeg_6,
}:

buildPythonPackage (finalAttrs: {
  pname = "ffpyplayer";
  version = "4.5.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matham";
    repo = "ffpyplayer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dzSORPNXQ82d9fmfuQa8RcxDu5WbUBJEDG/SWQLJ6i0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "cython~=3.0.11" \
        "cython"
    substituteInPlace setup.py \
      --replace-fail \
        "cython~=3.0.11" \
        "cython"
  '';

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    (lib.getDev SDL2)
    (lib.getDev ffmpeg_6)
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
    ];
  };

  pythonImportsCheck = [ "ffpyplayer" ];

  # No proper test suite
  doCheck = false;

  meta = {
    changelog = "https://github.com/matham/ffpyplayer/releases/tag/v${finalAttrs.version}";
    description = "A cython implementation of an ffmpeg based player";
    homepage = "https://github.com/matham/ffpyplayer";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
