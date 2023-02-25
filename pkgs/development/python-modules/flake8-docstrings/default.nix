{ lib
, buildPythonPackage
, fetchPypi
, flake8
, pydocstyle
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flake8-docstrings";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n+fGowYGSvjmKgVcL2Hp6x2lX4S7OcrvK4TOU3CKw0s=";
  };

  propagatedBuildInputs = [
    flake8
    pydocstyle
  ];

  pythonImportsCheck = [
    "flake8_docstrings"
  ];

  meta = with lib; {
    description = "Extension for flake8 which uses pydocstyle to check docstrings";
    homepage = "https://github.com/pycqa/flake8-docstrings";
    changelog = "https://github.com/PyCQA/flake8-docstrings/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
