{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, flit-core
, attrs
, cattrs
, jsonschema
, importlib-resources
, pyhamcrest
}:

buildPythonPackage rec {
  pname = "lsprotocol";
  version = "2022.0.0a9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = version;
    hash = "sha256-6XecPKuBhwtkmZrGozzO+VEryI5wwy9hlvWE1oV6ajk=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ attrs cattrs ];

  checkInputs = [
    pytestCheckHook
    importlib-resources
    jsonschema
    pyhamcrest
  ];

  pythonImportsCheck = [ "lsprotocol" ];

  meta = with lib; {
    description = "lsprotocol is a python implementation of object types used in the Language Server Protocol (LSP)";
    homepage = "https://github.com/microsoft/lsprotocol";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
