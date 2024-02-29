{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, ffmpeg-full
, pytestCheckHook
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.25.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jiaaro";
    repo = "pydub";
    rev = "refs/tags/v${version}";
    hash = "sha256-FTEMT47wPXK5i4ZGjTVAhI/NjJio3F2dbBZzYzClU3c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    ffmpeg-full
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydub"
    "pydub.audio_segment"
    "pydub.playback"
  ];

  pytestFlagsArray = [
    "test/test.py"
  ];

  meta = with lib; {
    description = "Manipulate audio with a simple and easy high level interface";
    homepage = "http://pydub.com";
    changelog = "https://github.com/jiaaro/pydub/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
