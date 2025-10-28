{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  poetry-core,
  psycopg,
  psycopg-pool,
  pytestCheckHook,
  pytest-asyncio,
  pytest-xdist,
  redis,
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-xdist
    redisTestHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # hangs
    "test_limiter_01"
  ];

  pythonImportsCheck = [ "pyrate_limiter" ];

  meta = with lib; {
    description = "Python Rate-Limiter using Leaky-Bucket Algorimth Family";
    homepage = "https://github.com/vutran1710/PyrateLimiter";
    changelog = "https://github.com/vutran1710/PyrateLimiter/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
