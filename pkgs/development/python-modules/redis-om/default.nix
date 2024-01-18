{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, unasync
, poetry-core
, python
, click
, hiredis
, more-itertools
, pydantic
, python-ulid
, redis
, types-redis
, typing-extensions
, pkgs
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "redis-om";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis-om-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-jQS0VTYZeAj3+OVFy+JP4mUFBPo+a5D/kdJKagFraaA=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    unasync
    poetry-core
  ];

  # it has not been maintained at all for a half year and some dependencies are outdated
  # https://github.com/redis/redis-om-python/pull/554
  # https://github.com/redis/redis-om-python/pull/577
  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    click
    hiredis
    more-itertools
    pydantic
    python-ulid
    redis
    types-redis
    typing-extensions
  ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} make_sync.py
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  # probably require redisearch
  # https://github.com/redis/redis-om-python/issues/532
  doCheck = false;

  pythonImportsCheck = [
    "aredis_om"
    "redis_om"
  ];

  meta = with lib; {
    description = "Object mapping, and more, for Redis and Python";
    homepage = "https://github.com/redis/redis-om-python";
    changelog = "https://github.com/redis/redis-om-python/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
