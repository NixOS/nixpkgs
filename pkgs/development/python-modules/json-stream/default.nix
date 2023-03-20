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
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vg6zF4iR4YqVAsx93Gy5mO2JNldm2f7BhNBtjzVY82w=";
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
