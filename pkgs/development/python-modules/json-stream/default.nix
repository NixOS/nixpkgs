{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "1.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-htajifmbXtivUwsORzBzJA68nJCACcL75kiBysVYCxY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "json_stream"
  ];

  disabledTests = [
    "test_writer"
  ];

  meta = with lib; {
    description = "Streaming JSON parser";
    homepage = "https://github.com/daggaz/json-stream";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
