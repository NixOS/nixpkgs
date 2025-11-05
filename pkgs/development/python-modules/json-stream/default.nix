{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  iconv,
  pytestCheckHook,
  pythonOlder,
  requests,
  json-stream-rs-tokenizer,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "daggaz";
    repo = "json-stream";
    tag = "v${version}";
    hash = "sha256-bhyoTvILap0/dKpmob6P1l9st7JwuHaLp7Y8FGfgLZA=";
  };

  build-system = [ setuptools ];

  dependencies = [ json-stream-rs-tokenizer ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ iconv ];

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
