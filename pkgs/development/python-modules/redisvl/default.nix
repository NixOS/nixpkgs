{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  nix-update-script,
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
  version = "0.18.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis-vl-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2yByWnnHYUBsjUCqyEv70+S0GCFEb7y2BGw4kHbaC+0=";
  };

  build-system = [ hatchling ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python client library and CLI for using Redis as a vector database";
    homepage = "https://github.com/redis/redis-vl-python";
    changelog = "https://github.com/redis/redis-vl-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "rvl";
    maintainers = with lib.maintainers; [ codgician ];
  };
})
