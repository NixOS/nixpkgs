{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  poetry-core,

  # deps
  httpcore,
  httpx2,
  openai,
  pydantic,
  python-dotenv,
  requests,
  typing-extensions,

  # tests
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "exa-py";
  version = "2.21.0";
  pyproject = true;
  __structuredAttrs = true;

  # pypi doesn't include tests but there aren't any upstream git tags
  src = fetchFromGitHub {
    owner = "exa-labs";
    repo = "exa-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PKle41FWfs5L4S+HY4iP6WLAVc3GonXLjbGk9mmFsW8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    httpcore
    httpx2
    openai
    pydantic
    python-dotenv
    requests
    typing-extensions
  ];

  pythonImportsCheck = [
    "exa_py"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pytestFlags = [ "tests/" ];

  meta = {
    description = "Official Python SDK for Exa, the web search API for AI";
    homepage = "https://github.com/exa-labs/exa-py/";
    changelog = "https://github.com/exa-labs/exa-py/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.mit;
  };
})
