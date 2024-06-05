{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
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
  version = "12.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "PyAV-Org";
    repo = "PyAV";
    rev = "refs/tags/v${version}";
    hash = "sha256-ezeYv55UzNnnYDjrMz5YS5g2pV6U/Fxx3e2bCoPP3eI=";
  };

  patches = [
    # call pytest.skip() in certain functions using the network when SKIP_NETWORK_TESTS is set
    ./allow-skipping-network-tests.patch
  ];

  env.SKIP_NETWORK_TESTS = "1";

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg-headless ];

  preCheck = ''
    # ensure we import the built package from $out
    rm -r av
  '';

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # Error: Invalid data found when processing input: 'custom_io_output.mpd'
    # Probably has to do something with the fact that this is using the @run_in_sandbox decorator
    "test_writing_to_custom_io_dash"
  ];

  pythonImportsCheck = [
    "av"
    "av._core"
    "av.audio"
    "av.bitstream"
    "av.buffer"
    "av.bytesource"
    "av.codec"
    "av.container"
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
    "av.sidedata"
    "av.stream"
    "av.subtitles"
    "av.utils"
    "av.video"
  ];

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    mainProgram = "pyav";
    homepage = "https://github.com/PyAV-Org/PyAV/";
    changelog = "https://github.com/PyAV-Org/PyAV/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
