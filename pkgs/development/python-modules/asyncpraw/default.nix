{
  lib,
  aiofiles,
  aiohttp,
  asyncprawcore,
  buildPythonPackage,
  coverage,
  defusedxml,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-asyncio,
  pytest-vcr,
  update-checker,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "asyncpraw";
  version = "7.8.1-unstable-2025-10-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "asyncpraw";
    rev = "9221cbef5d94fce9ecc92376cbab084f0082502d";
    hash = "sha256-/7x7XYw1JDVaoc2+wKWW3iUkyfI6MVtBNP9G1AEUp4Y=";
  };

  pythonRelaxDeps = [
    "coverage"
    "defusedxml"
  ];

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiohttp
    asyncprawcore
    coverage
    defusedxml
    update-checker
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
    changelog = "https://github.com/praw-dev/asyncpraw/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
