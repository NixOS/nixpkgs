{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,
  ffmpeg,

  # build-system
  setuptools,

  # checks
  psutil,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "imageio-ffmpeg";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "imageio";
    repo = "imageio-ffmpeg";
    rev = "refs/tags/v${version}";
    hash = "sha256-i9DBEhRyW5shgnhpaqpPLTI50q+SATJnxur8PAauYX4=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-path.patch;
      ffmpeg = lib.getExe ffmpeg;
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  disabledTestPaths = [
    # network access
    "tests/test_io.py"
    "tests/test_special.py"
    "tests/test_terminate.py"
  ];

  postCheck = ''
    ${python.interpreter} << EOF
    from imageio_ffmpeg import get_ffmpeg_version
    assert get_ffmpeg_version() == '${ffmpeg.version}'
    EOF
  '';

  pythonImportsCheck = [ "imageio_ffmpeg" ];

  meta = with lib; {
    changelog = "https://github.com/imageio/imageio-ffmpeg/releases/tag/v${version}";
    description = "FFMPEG wrapper for Python";
    homepage = "https://github.com/imageio/imageio-ffmpeg";
    license = licenses.bsd2;
    maintainers = [ maintainers.pmiddend ];
  };
}
