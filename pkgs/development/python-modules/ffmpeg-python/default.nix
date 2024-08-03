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
}:

buildPythonPackage {
  pname = "ffmpeg-python";
  version = "0.2.0-unstable-2022-07-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kkroening";
    repo = "ffmpeg-python";
    rev = "df129c7ba30aaa9ffffb81a48f53aa7253b0b4e6";
    hash = "sha256-jPiFhYRwfuS+vo6LsLw0+65NWy2A+B+EdC8SewZTRP4=";
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

  pythonImportsCheck = [ "ffmpeg" ];

  meta = {
    description = "Python bindings for FFmpeg - with complex filtering support";
    homepage = "https://github.com/kkroening/ffmpeg-python";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.emily ];
  };
}
