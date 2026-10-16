{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython_3_3,
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

buildPythonPackage (finalAttrs: {
  pname = "av";
  version = "19.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PyAV-Org";
    repo = "PyAV";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QH/cHXR6Vo/Bg5tiwq2Avjb0ITTBWodgpAgqJGpvzh4=";
  };

  build-system = [
    cython_3_3
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

  disabledTests = [
    # network access
    "test_index_entries_len_webm"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "av"
    "av.audio"
    "av.buffer"
    "av.codec"
    "av.container"
    "av._core"
    "av.datasets"
    "av.dictionary"
    "av.error"
    "av.filter"
    "av.format"
    "av.frame"
    "av.logging"
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
    changelog = "https://github.com/PyAV-Org/PyAV/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
