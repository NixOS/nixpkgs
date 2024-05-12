{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
, pytest-cov
}:

buildPythonPackage rec {
  pname = "pynmeagps";
  version = "1.0.36";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pynmeagps";
    rev = "refs/tags/v${version}";
    hash = "sha256-n7dCr85TeBLxdrD1ZAA7PGJd9+3+xFJ8gjRU/JOFysY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [
    "pynmeagps"
  ];

  meta = {
    homepage = "https://github.com/semuconsulting/pynmeagps";
    description = "NMEA protocol parser and generator";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dylan-gonzalez ];
  };
}
