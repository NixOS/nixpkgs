{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  unasync,
  poetry-core,
  python,
  click,
  hiredis,
  more-itertools,
  pydantic,
  python-ulid,
  redis,
  redisTestHook,
  types-redis,
  typing-extensions,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "redis-om";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis-om-python";
    tag = "v${version}";
    hash = "sha256-TfwMYDZYDKCdI5i8izBVZaXN5GC/Skhkl905c/DHuXY=";
  };

  patches = [
    # Include redis_om package, https://github.com/redis/redis-om-python/pull/718
    (fetchpatch {
      name = "include-redis_om.patch";
      url = "https://github.com/redis/redis-om-python/commit/cc03485f148dcc2f455dd8cafd3b116758504c50.patch";
      hash = "sha256-UzQfRbLCTnKW5jxQhldI9KCuN//bx3/PvNnfd872D+o=";
    })
  ];

  build-system = [
    unasync
    poetry-core
  ];

  # it has not been maintained at all for a half year and some dependencies are outdated
  # https://github.com/redis/redis-om-python/pull/554
  # https://github.com/redis/redis-om-python/pull/577
  pythonRelaxDeps = true;

  dependencies = [
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
    redisTestHook
  ];

  # probably require redisearch
  # https://github.com/redis/redis-om-python/issues/532
  doCheck = false;

  pythonImportsCheck = [
    "aredis_om"
    "redis_om"
  ];

  meta = with lib; {
    description = "Object mapping, and more, for Redis and Python";
    mainProgram = "migrate";
    homepage = "https://github.com/redis/redis-om-python";
    changelog = "https://github.com/redis/redis-om-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
