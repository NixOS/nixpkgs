{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "classify-imports";
  version = "4.2.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f5wZfisKz9WGdq6u0rd/zg2CfMwWvQeR8xZQNbD7KfU=";
  };

  pythonImportsCheck = [
    "classify_imports"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Utilities for refactoring imports in python-like syntax";
    homepage = "https://github.com/asottile/classify-imports";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
