{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  cython,
  setuptools,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  ffmpeg-headless,

  # dependencies

  fetchurl,
  linkFarm,
  numpy,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "av";
  version = "16.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyAV-Org";
    repo = "PyAV";
    tag = "v${version}";
    hash = "sha256-mz0VI72lqtur5HdCkPNxInk0pUWxji0boIZnfvdrxIs=";
  };

  patches = [
    # Upstream PR: https://github.com/PyAV-Org/PyAV/pull/2204
    (fetchpatch {
      name = "ffmpeg-8.1-compat-test_skip_samples_remux.patch";
      url = "https://github.com/PyAV-Org/PyAV/commit/57d8f4d7215a7b7cc7d01415613fc6aa2831a8d3.patch";
      hash = "sha256-bDp8p2Qy9tU1GD9YqxU3O0ozPxhX/Fu9p9Zy1BIlPXA=";
    })
    # Upstream PR: https://github.com/PyAV-Org/PyAV/pull/2205
    (fetchpatch {
      name = "ffmpeg-8.1-compat-test_reformat_pixel_format_align.patch";
      url = "https://github.com/PyAV-Org/PyAV/commit/900e39b9f0f7df33c3ea192b6dc13736e0b1561c.patch";
      hash = "sha256-5SDLg5kQl2XjKX73rEIVSTznWAbC1oHr6EXfcufwhNM=";
    })
  ];

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg-headless ];

  preCheck =
    let
      # Update with `./update-test-samples.bash` if necessary.
      testSamples = linkFarm "pyav-test-samples" (
        lib.mapAttrs (_: fetchurl) (lib.importTOML ./test-samples.toml)
      );
    in
    ''
      # ensure we import the built version
      rm -r av
      ln -s ${testSamples} tests/assets
    '';

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "av"
    "av.audio"
    "av.buffer"
    "av.bytesource"
    "av.codec"
    "av.container"
    "av._core"
    "av.datasets"
    "av.descriptor"
    "av.dictionary"
    "av.error"
    "av.filter"
    "av.format"
    "av.frame"
    "av.logging"
    "av.option"
    "av.packet"
    "av.plane"
    "av.stream"
    "av.subtitles"
    "av.utils"
    "av.video"
  ];

  meta = {
    description = "Pythonic bindings for FFmpeg";
    mainProgram = "pyav";
    homepage = "https://github.com/PyAV-Org/PyAV";
    changelog = "https://github.com/PyAV-Org/PyAV/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
