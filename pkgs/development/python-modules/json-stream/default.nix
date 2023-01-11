{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
, json-stream-rs-tokenizer
, setuptools
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "2.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NppHSfgelHXNOHxEq5AImVoxeFCcscitkLR9v/bIM5Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
    json-stream-rs-tokenizer
  ];

  checkInputs = [
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
