{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  pyyaml,
  redis,
  pydantic,
  tenacity,
  ml-dtypes,
  python-ulid,
  jsonpath-ng,
}:

buildPythonPackage (finalAttrs: {
  pname = "redisvl";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis-vl-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-za3ZFvB8/BiQrzjEC2iF33tpAI/l5ghZzoVpN5ISUco=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "redis" ];

  dependencies = [
    numpy
    pyyaml
    redis
    pydantic
    tenacity
    ml-dtypes
    python-ulid
    jsonpath-ng
  ];

  pythonImportsCheck = [ "redisvl" ];

  # tests require a live Redis server with the search/vector module
  doCheck = false;

  meta = {
    description = "Python client library and CLI for using Redis as a vector database";
    homepage = " https://redisvl.com";
    changelog = "https://github.com/redis/redis-vl-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "rvl";
    maintainers = with lib.maintainers; [ codgician ];
    teams = [ lib.teams.redis ];
  };
})
