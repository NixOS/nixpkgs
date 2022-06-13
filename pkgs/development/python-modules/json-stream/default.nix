{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J5DBa8zeandkDIXpEaRN6cneZIIG2aRHS5zjmM/H0Uw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "json_stream"
  ];

  meta = with lib; {
    description = "Streaming JSON parser";
    homepage = "https://github.com/daggaz/json-stream";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
