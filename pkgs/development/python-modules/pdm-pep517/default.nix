{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, git
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "pdm-pep517";
  version = "0.9.4";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2o2FuuvS5PW7uhxl3EGBP75CZ3dcyjPoug1k0irl51c=";
  };

  disabledTests = [
    "test_project_version_use_scm"
  ];

  checkInputs = [
    git
    pytestCheckHook
    pytest-cov
  ];

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-pep517";
    description = "Yet another PEP 517 backend.";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
