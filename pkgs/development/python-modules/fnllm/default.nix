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
  polyfactory,
  pydantic,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  tenacity,
  tiktoken,
}:

buildPythonPackage rec {
  pname = "fnllm";
  version = "0.2.8";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FafxygW5aZ3U24mesFZI5cmLd1L1FE8rHOrOgL3R+9g=";
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
    polyfactory
    pytest-asyncio
    pytest-cov-stub
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
    "test_text_service_encode_decode"
    "test_count_tokens"
    "trim_to_max_tokens"
    "test_split"
    "test_clear"
    "test_handles_common_errors"
    "test_children"
  ];

  meta = {
    description = "A function-based LLM protocol and wrapper";
    homepage = "https://github.com/microsoft/essex-toolkit/tree/main/python/fnllm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
