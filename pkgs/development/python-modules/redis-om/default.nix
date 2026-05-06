{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unasync,
  python,
  click,
  hiredis,
  more-itertools,
  pydantic,
  pydantic-extra-types,
  python-ulid,
  redis,
  redisvl,
  redisTestHook,
  types-redis,
  typing-extensions,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "redis-om";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis-om-python";
    tag = "v${version}";
    hash = "sha256-qjGrhEINW9p2Rd3O5WI4QKYcj8tn/FI3pjnhI1k3mmc=";
  };

  build-system = [
    hatchling
    unasync
  ];

  dependencies = [
    click
    hiredis
    more-itertools
    pydantic
    pydantic-extra-types
    python-ulid
    redis
    redisvl
    types-redis
    typing-extensions
  ];

  postPatch = ''
    # We don't want to use a formatter in our build.
    substituteInPlace make_sync.py \
      --replace-fail 'ruff' 'true'

    # Fix `click` not finding the correct package to use for the version command.
    substituteInPlace aredis_om/cli/main.py \
      --replace-fail '@click.version_option()' '@click.version_option(package_name = "redis_om")'
  '';

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

  meta = {
    description = "Object mapping, and more, for Redis and Python";
    mainProgram = "om";
    homepage = "https://github.com/redis/redis-om-python";
    changelog = "https://github.com/redis/redis-om-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    teams = [ lib.teams.redis ];
  };
}
