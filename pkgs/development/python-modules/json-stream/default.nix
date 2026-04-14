{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  iconv,
  pytestCheckHook,
  requests,
  json-stream-rs-tokenizer,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json-stream";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daggaz";
    repo = "json-stream";
    tag = "v${version}";
    hash = "sha256-iSJY53VImv9GSIC2IB969zzYYNg7gFKJH8QQFpjzrQU=";
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

  meta = {
    description = "Streaming JSON parser";
    homepage = "https://github.com/daggaz/json-stream";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
