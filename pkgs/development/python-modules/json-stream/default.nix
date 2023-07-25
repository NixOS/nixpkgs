{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, iconv
, pytestCheckHook
, pythonOlder
, requests
, json-stream-rs-tokenizer
, setuptools
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "2.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MwDpX3ISJxo0Am3t/uuUC8GTyZFuUFGt1g7BeTY1z/0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    iconv
  ];

  propagatedBuildInputs = [
    requests
    json-stream-rs-tokenizer
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
