{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # optional dependencies
  filelock,
  psycopg,
  psycopg-pool,
  redis,

  # test
  pytestCheckHook,
  pytest-asyncio,
  pytest-xdist,
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "pyrate-limiter";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vutran1710";
    repo = "PyrateLimiter";
    tag = "v${version}";
    hash = "sha256-2gWbabdRqwWiC4xbMx/VGBwwMcygVMKJswXgd4Ia+xE=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  optional-dependencies = {
    all = [
      filelock
      redis
      psycopg
      psycopg-pool
    ];
  };

  # Show each test name and track the slowest
  # This helps with identifying bottlenecks in the test suite
  # that are causing the build to time out on Hydra.
  pytestFlags = [
    "--durations=10"
    "-vv"
  ];

  nativeCheckInputs = [
    filelock
    pytestCheckHook
    pytest-asyncio
    pytest-xdist
    redis
    redisTestHook
  ];

  disabledTestPaths = [
    # Slow: > 1.5 seconds/test run standalone on a fast machine
    # (Apple M3 Max with highest performance settings and 36GB RAM)
    # and/or hang under load
    # https://github.com/vutran1710/PyrateLimiter/issues/245
    # https://github.com/vutran1710/PyrateLimiter/issues/247
    "tests/test_bucket_all.py"
    "tests/test_bucket_factory.py"
    "tests/test_limiter.py"
    "tests/test_multiprocessing.py"
    "tests/test_postgres_concurrent.py"
    "tests/test_multi_bucket.py"
  ];

  # For redisTestHook
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyrate_limiter" ];

  meta = {
    description = "Python Rate-Limiter using Leaky-Bucket Algorimth Family";
    homepage = "https://github.com/vutran1710/PyrateLimiter";
    changelog = "https://github.com/vutran1710/PyrateLimiter/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
