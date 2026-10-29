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
  version = "2.12.0-unstable-2026-04-15";
  pyproject = true;
  __structuredAttrs = true;

  # pypi doesn't include tests but there aren't any upstream git tags
  src = fetchFromGitHub {
    owner = "exa-labs";
    repo = "exa-py";
    rev = "af7f88999763f1cb7e3c4a67f4aa24cef5f6eb11";
    hash = "sha256-7rLEvjngSRObFdT1DcrZfqWBCsvWVxdNIgxBNhNNk+4=";
  };

  # https://github.com/pytest-dev/pytest-asyncio/issues/658
  # default behaviour changes with new python version.
  # planning on trying to vendor upstream
  postPatch = ''
    substituteInPlace tests/unit/test_search_monitors.py --replace-fail \
      'get_event_loop().run_until_complete' 'run'
  '';

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
