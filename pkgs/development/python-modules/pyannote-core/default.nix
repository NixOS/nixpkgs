{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, sortedcontainers
, numpy
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pyannote-core";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-core";
    rev = version;
    hash = "sha256-XQVEMy60LkfFr2TKXTeg6cGHRx5BUZ5qDgzIdKy/19Y=";
  };

  propagatedBuildInputs = [
    sortedcontainers
    numpy
    scipy
    typing-extensions
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "pyannote.core" ];

  meta = with lib; {
    description = "Advanced data structures for handling temporal segments with attached labels";
    homepage = "https://github.com/pyannote/pyannote-core";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
