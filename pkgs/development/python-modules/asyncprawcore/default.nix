{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pytest-asyncio,
  pytest-vcr,
  vcrpy,
  yarl,
}:

buildPythonPackage rec {
  pname = "asyncprawcore";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "asyncprawcore";
    tag = "v${version}";
    hash = "sha256-0FOMY/0LXGcHwDe4t+NMAovMhX83/mMv8sWvIf5gxok=";
  };

  build-system = [ flit-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-vcr
    vcrpy
  ];

  disabledTestPaths = [
    # Ignored due to error with request cannot pickle 'BufferedReader' instances
    # Upstream issue: https://github.com/kevin1024/vcrpy/issues/737
    "tests/integration/test_sessions.py"
  ];

  disabledTests = [
    # Test requires network access
    "test_initialize"
  ];

  pythonImportsCheck = [ "asyncprawcore" ];

  meta = {
    description = "Low-level asynchronous communication layer for Async PRAW";
    homepage = "https://asyncpraw.readthedocs.io/";
    changelog = "https://github.com/praw-dev/asyncprawcore/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
