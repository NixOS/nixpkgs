{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,
  setuptools,
  future,
  pytestCheckHook,
  pytest-mock,
  ffmpeg_4,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "ffmpeg-python";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kkroening";
    repo = "ffmpeg-python";
    rev = version;
    hash = "sha256-Dk3nHuYVlIiFF6nORZ5TVFkBXdoZUxLfoiz68V1tvlY=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-location.patch;
      ffmpeg = ffmpeg_4;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ future ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  pythonImportsCheck = [ "ffmpeg" ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [ "test__output__video_size" ];

  meta = {
    description = "Python bindings for FFmpeg - with complex filtering support";
    homepage = "https://github.com/kkroening/ffmpeg-python";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
