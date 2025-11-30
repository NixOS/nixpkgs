{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flake8,
  pydocstyle,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "flake8-docstrings";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8-docstrings";
    tag = version;
    hash = "sha256-EafLWySeHB81HRcXiDs56lbUZzGvnT87WVqln0PoLCk=";
  };

  propagatedBuildInputs = [
    flake8
    pydocstyle
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "flake8_docstrings" ];

  meta = with lib; {
    description = "Extension for flake8 which uses pydocstyle to check docstrings";
    homepage = "https://github.com/pycqa/flake8-docstrings";
    changelog = "https://github.com/PyCQA/flake8-docstrings/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
