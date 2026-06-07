{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  poetry-core,

  # deps
  httpcore,
  httpx,
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

  # passthru
  unstableGitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "exa-py";
  version = "2.13.1-unstable-2026-06-03";
  pyproject = true;
  __structuredAttrs = true;

  # pypi doesn't include tests but there aren't any upstream git tags
  src = fetchFromGitHub {
    owner = "exa-labs";
    repo = "exa-py";
    rev = "42fde906ecd069c15ad4888e1585b395a0db7edf";
    hash = "sha256-6o4SKAeP5q+57LCbbw5vP7r/dEA1HiQNa9CkopbTlxg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    httpcore
    httpx
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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Official Python SDK for Exa, the web search API for AI";
    homepage = "https://github.com/exa-labs/exa-py/";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.mit;
  };
})
