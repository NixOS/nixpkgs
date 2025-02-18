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
  # https://github.com/matham/ffpyplayer/issues/166
  ffmpeg_6,
}:

buildPythonPackage rec {
  pname = "ffpyplayer";
  version = "4.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matham";
    repo = "ffpyplayer";
    tag = "v${version}";
    hash = "sha256-8NBTVN+MPeJfDHuzF45qIK46q5VbiwxipAvjgqdiWrw=";
  };

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
    NIX_CFLAGS_COMPILE = toString ([
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
    ]);
  };

  pythonImportsCheck = [ "ffpyplayer" ];

  # No proper test suite
  doCheck = false;

  meta = {
    description = "A cython implementation of an ffmpeg based player";
    homepage = "https://github.com/matham/ffpyplayer";
    changelog = "https://github.com/matham/ffpyplayer/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
