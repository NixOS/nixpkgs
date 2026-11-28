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

buildPythonPackage (finalAttrs: {
  pname = "json-stream";
  version = "2.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daggaz";
    repo = "json-stream";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UC9+F+AeAKxY8hN+b0LvXETy9uNjBs+4GA7xGXeD+wU=";
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
})
