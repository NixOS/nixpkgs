{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  SDL2,
  pkg-config,
  ffmpeg_6,
}:

buildPythonPackage rec {
  pname = "ffpyplayer";
  version = "4.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i5Yj4EmXunu/VHYxOqjZ6uJmXGX0A7Xe/0rFHxYVXn4=";
  };

  patches = [ ./sws_scale_ptr.patch ]; # https://github.com/matham/ffpyplayer/pull/182
  patchFlags = [
    "-p1"
    "--binary"
  ]; # CRLFs in pypi src dist

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [ pkg-config ];

  dependencies = [
    SDL2
    # https://github.com/matham/ffpyplayer/issues/166 blocks updating to 7
    ffmpeg_6
  ];

  meta = {
    description = "Python binding for the FFmpeg library for playing and writing media files";
    homepage = "https://matham.github.io/ffpyplayer/index.html";
    license = lib.licenses.lgpl3Only;
  };
}
