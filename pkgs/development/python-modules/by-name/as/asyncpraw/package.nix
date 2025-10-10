{
  lib,
  aiofiles,
  aiohttp,
  aiosqlite,
  asyncprawcore,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mock,
  pytestCheckHook,
  pytest-asyncio_0,
  pytest-vcr,
  pythonOlder,
  requests-toolbelt,
  update-checker,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "asyncpraw";
  version = "7.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "asyncpraw";
    tag = "v${version}";
    hash = "sha256-glWAQoUjMFbjU3C4+MGuRGSGJS9mun15+6udMPCf9nU=";
  };

  pythonRelaxDeps = [ "aiosqlite" ];

  # 'aiosqlite' is also checked when building the wheel
  pypaBuildFlags = [ "--skip-dependency-check" ];

  build-system = [ flit-core ];

  dependencies = [
    aiofiles
    aiohttp
    aiosqlite
    asyncprawcore
    mock
    update-checker
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio_0
    pytest-vcr
    vcrpy
    requests-toolbelt
  ];

  disabledTestPaths = [
    # Ignored due to error with request cannot pickle 'BufferedReader' instances
    # Upstream issue: https://github.com/kevin1024/vcrpy/issues/737
    "tests/integration/models/reddit/test_emoji.py"
    "tests/integration/models/reddit/test_submission.py"
    "tests/integration/models/reddit/test_subreddit.py"
    "tests/integration/models/reddit/test_widgets.py"
    "tests/integration/models/reddit/test_wikipage.py"
  ];

  pythonImportsCheck = [ "asyncpraw" ];

  meta = {
    description = "Asynchronous Python Reddit API Wrapper";
    homepage = "https://asyncpraw.readthedocs.io/";
    changelog = "https://github.com/praw-dev/asyncpraw/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
