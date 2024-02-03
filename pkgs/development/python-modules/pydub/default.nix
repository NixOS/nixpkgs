{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub

# tests
, ffmpeg-full
, python
}:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.25.1";
  format = "setuptools";

  # pypi version doesn't include required data files for tests
  src = fetchFromGitHub {
    owner = "jiaaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xskllq66wqndjfmvp58k26cv3w480sqsil6ifwp4gghir7hqc8m";
  };

  pythonImportsCheck = [
    "pydub"
    "pydub.audio_segment"
    "pydub.playback"
  ];

  nativeCheckInputs = [
    ffmpeg-full
  ];

  checkPhase = ''
    ${python.interpreter} test/test.py
  '';

  meta = with lib; {
    description = "Manipulate audio with a simple and easy high level interface";
    homepage = "http://pydub.com";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
