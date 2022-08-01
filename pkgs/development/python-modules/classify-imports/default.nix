{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "classify-imports";
  version = "4.1.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w/+Sf2ZVSDmFNPICJfAKzfukcznWyFBhi7hjIELtYGI=";
  };

  pythonImportsCheck = [
    "classify_imports"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Utilities for refactoring imports in python-like syntax";
    homepage = "https://github.com/asottile/classify-imports";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
