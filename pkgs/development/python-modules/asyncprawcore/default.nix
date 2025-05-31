{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mock,
  pytestCheckHook,
  pytest-asyncio,
  pytest-vcr,
  pythonOlder,
  requests,
  requests-toolbelt,
  testfixtures,
  vcrpy,
  yarl,
}:

buildPythonPackage rec {
  pname = "asyncprawcore";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "asyncprawcore";
    tag = "v${version}";
    hash = "sha256-FDQdtnNjsbiEp9BUYdQFMC/hkyJDhCh2WHhQWSQwrFY=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    requests
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    testfixtures
    mock
    requests-toolbelt
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

  pythonImportsCheck = [ "asyncprawcore" ];

  meta = {
    description = "Low-level asynchronous communication layer for Async PRAW";
    homepage = "https://asyncpraw.readthedocs.io/";
    changelog = "https://github.com/praw-dev/asyncprawcore/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
