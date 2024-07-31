{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  fetchurl,
  linkFarm,
  ffmpeg_6-headless,
  numpy,
  pillow,
  pkg-config,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "av";
  version = "12.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mikeboers";
    repo = "PyAV";
    rev = "refs/tags/v${version}";
    hash = "sha256-yPVAtL71pL/ok3bli+r/IruCrmmhNyv98pr7z3m8sbo=";
  };

  nativeBuildInputs = [
    cython
    pkg-config
    setuptools
  ];

  buildInputs = [ ffmpeg_6-headless ];

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
    # av.error.InvalidDataError: [Errno 1094995529] Invalid data found when processing input: 'custom_io_output.mpd'
    "test_writing_to_custom_io_dash"
  ];

  # `__darwinAllowLocalNetworking` doesn’t work for these; not sure why.
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/test_timeout.py"
  ];

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
    "av.enum"
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

  meta = with lib; {
    description = "Pythonic bindings for FFmpeg/Libav";
    mainProgram = "pyav";
    homepage = "https://github.com/mikeboers/PyAV/";
    changelog = "https://github.com/PyAV-Org/PyAV/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
