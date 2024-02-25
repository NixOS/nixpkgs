{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "pyasyncore";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "pyasyncore";
    rev = "refs/tags/v${version}";
    hash = "sha256-e1iHC9mbQYlfpIdLk033wvoA5z5WcHjOZm6oFTfpRTA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "asyncore"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Make asyncore available for Python 3.12 onwards";
    homepage = "https://github.com/simonrob/pyasyncore";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
  };
}
