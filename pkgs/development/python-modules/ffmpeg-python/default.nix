{ lib
, buildPythonPackage
, fetchFromGitHub
, ffmpeg_4
, future
, pytest-mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, substituteAll
}:

buildPythonPackage rec {
  pname = "ffmpeg-python";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kkroening";
    repo = "ffmpeg-python";
    rev = version;
    hash = "sha256-Dk3nHuYVlIiFF6nORZ5TVFkBXdoZUxLfoiz68V1tvlY=";
  };

  propagatedBuildInputs = [
    future
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  patches = [
    (substituteAll {
      src = ./ffmpeg-location.patch;
      ffmpeg = ffmpeg_4;
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  pythonImportsCheck = [
    "ffmpeg"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    "test__output__video_size"
  ];

  meta = with lib; {
    description = "Python bindings for FFmpeg - with complex filtering support";
    homepage = "https://github.com/kkroening/ffmpeg-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
