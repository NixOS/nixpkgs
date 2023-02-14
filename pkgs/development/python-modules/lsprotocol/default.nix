{ lib
, attrs
, buildPythonPackage
, cattrs
, fetchFromGitHub
, flit-core
, jsonschema
, pyhamcrest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lsprotocol";
  version = "2022.0.0a9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-6XecPKuBhwtkmZrGozzO+VEryI5wwy9hlvWE1oV6ajk=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
  ];

  nativeCheckInputs = [
    jsonschema
    pyhamcrest
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lsprotocol"
  ];

  meta = with lib; {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/microsoft/lsprotocol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar fab ];
  };
}
