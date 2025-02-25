{
  lib,
  aiolimiter,
  azure-identity,
  azure-storage-blob,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  httpx,
  json-repair,
  openai,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  tenacity,
  tiktoken,
}:

buildPythonPackage rec {
  pname = "fnllm";
  version = "0.0.14";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HZsOqETSDezQQKmCPeib4EztgO2VKtwM0dxnAl/H3/s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiolimiter
    httpx
    json-repair
    pydantic
    tenacity
  ];

  optional-dependencies = {
    azure = [
      azure-identity
      azure-storage-blob
    ];
    openai = [
      openai
      tiktoken
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "fnllm" ];

  disabledTests = [
    # Tests require network access
    "chat"
    "embeddings"
    "rate_limited"
    "test_default_operations"
    "test_estimate_request_tokens"
    "test_replace_value"
  ];

  disabledTestPaths = [
    "tests/unit/caching/test_blob.py"
  ];

  meta = {
    description = "A function-based LLM protocol and wrapper";
    homepage = "https://github.com/microsoft/essex-toolkit/tree/main/python/fnllm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
