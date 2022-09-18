{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zsjKOqkXy3Je7z8U4M016a4t2cWdUqL2tf27Dc8a/gw=";
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
