{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

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
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vutran1710";
    repo = "PyrateLimiter";
    tag = "v${version}";
    hash = "sha256-CAN3OWxXQaAzrh2q6z0OxPs4i02L/g2ISYFdUMHsHpg=";
  };

  postPatch = ''
    # tests cause too many connections to the postgres server and crash/timeout
    sed -i "/create_postgres_bucket,/d" tests/conftest.py
  '';

  build-system = [ poetry-core ];

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
    pytestCheckHook
    pytest-asyncio
    pytest-xdist
    redisTestHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
  ];

  pythonImportsCheck = [ "pyrate_limiter" ];

  meta = {
    description = "Python Rate-Limiter using Leaky-Bucket Algorimth Family";
    homepage = "https://github.com/vutran1710/PyrateLimiter";
    changelog = "https://github.com/vutran1710/PyrateLimiter/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
