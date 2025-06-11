{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
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
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "imageio";
    repo = "imageio-ffmpeg";
    tag = "v${version}";
    hash = "sha256-Yy2PTNBGPP/BAR7CZck/9qr2g/s4ntiuydqXz77hR7E=";
  };

  patches = [
    (replaceVars ./ffmpeg-path.patch {
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
    changelog = "https://github.com/imageio/imageio-ffmpeg/releases/tag/${src.tag}";
    description = "FFMPEG wrapper for Python";
    homepage = "https://github.com/imageio/imageio-ffmpeg";
    license = licenses.bsd2;
    maintainers = [ maintainers.pmiddend ];
  };
}
