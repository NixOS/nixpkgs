{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, mccabe
, pycodestyle
, pyflakes
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "6.1.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8";
    rev = version;
    hash = "sha256-N8bufkn1CUREHusVc2mQ1YlNr7lrESEZGmlN68bhgbE=";
  };

  propagatedBuildInputs = [
    mccabe
    pycodestyle
    pyflakes
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Flake8 is a wrapper around pyflakes, pycodestyle and mccabe.";
    homepage = "https://github.com/pycqa/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "flake8";
  };
}
