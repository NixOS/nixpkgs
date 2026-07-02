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

buildPythonPackage (finalAttrs: {
  pname = "asyncpraw";
  version = "8.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "asyncpraw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lVRIZP9XsUEM1Czl4YC10EdSC8RmO5ugPgo3THyqi9A=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "update-checker"
  ];

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiohttp
    asyncprawcore
    defusedxml
    update-checker
  ];

  nativeCheckInputs = [
    coverage
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
    changelog = "https://github.com/praw-dev/asyncpraw/blob/${finalAttrs.src.rev}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
})
