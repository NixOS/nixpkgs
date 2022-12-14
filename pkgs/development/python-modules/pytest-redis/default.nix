{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  port-for,
  mirakuru,
  redis,
  pytestCheckHook,
  pytest-cov,
  pytest-xdist,
  mock,
  pkgs,
}:
buildPythonPackage rec {
  pname = "pytest-redis";
  version = "2.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = "pytest-redis";
    rev = "v${version}";
    hash = "sha256-0sYY7DMBFNosnJ6EEA06tCE2LKk8F8ER2rLLYIUxn8I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pytest
    port-for
    mirakuru
    redis
  ];

  checkInputs = [pytestCheckHook pytest-cov pytest-xdist mock];

  pytestFlagsArray = [
    "--redis-exec=${pkgs.redis}/bin/redis-server"
    "--basetemp=$(mktemp -d)"
    "-k 'not test_second_redis'"
  ];

  pythonImportsCheck = [
    "pytest_redis"
    "pytest_redis.factories"
  ];

  meta = with lib; {
    description = "Redis fixtures and fixture factories for pytest";
    homepage = https://github.com/ClearcodeHQ/pytest-redis;
    license = licenses.lgpl3Only;
    maintainers = [maintainers.apeschar];
    platforms = platforms.all;
  };
}
