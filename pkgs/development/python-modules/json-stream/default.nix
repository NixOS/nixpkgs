{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  httpx,
  pytestCheckHook,
  pythonOlder,
  requests,
  json-stream-rs-tokenizer,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "2.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "json_stream";
    inherit version;
    hash = "sha256-iURExowzEXSSZ2PiJPs0t+0/kHSdHBZa/Q9ZMCB1NMQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ json-stream-rs-tokenizer ];

  optional-dependencies = {
    httpx = [ httpx ];
    requests = [ requests ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json_stream" ];

  disabledTests = [ "test_writer" ];

  meta = with lib; {
    description = "Streaming JSON parser";
    homepage = "https://github.com/daggaz/json-stream";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
