{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-speech-features";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jameslyons";
    repo = "python_speech_features";
    rev = version;
    hash = "sha256-IAQujxQ5hOXFNOIEhWsGOTeWqxyBmqL5HSVD4KYEn3U=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "python_speech_features"
  ];

  meta = {
    description = "Common speech features for ASR including MFCCs and filterbank energies";
    homepage = "https://github.com/jameslyons/python_speech_features";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
