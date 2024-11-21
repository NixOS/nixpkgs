{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  fetchurl,
  linkFarm,
  ffmpeg-headless,
  numpy,
  pillow,
  pkg-config,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "av";
  version = "13.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "PyAV-Org";
    repo = "PyAV";
    rev = "refs/tags/v${version}";
    hash = "sha256-x2a9SC4uRplC6p0cD7fZcepFpRidbr6JJEEOaGSWl60=";
  };

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

  disabledTests = [
    # av.error.InvalidDataError: [Errno 1094995529] Invalid data found when processing input: 'custom_io_output.mpd'
    "test_writing_to_custom_io_dash"
  ];

  # `__darwinAllowLocalNetworking` doesn’t work for these; not sure why.
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
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
    description = "Pythonic bindings for FFmpeg";
    mainProgram = "pyav";
    homepage = "https://github.com/PyAV-Org/PyAV";
    changelog = "https://github.com/PyAV-Org/PyAV/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
