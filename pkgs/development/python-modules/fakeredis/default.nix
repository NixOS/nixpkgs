{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  redisTestHook,

  hatchling,
  hypothesis,
  jsonpath-ng,
  lupa,
  numpy,
  pyprobables,
  pytest-asyncio,
  pytest-mock,
  redis,
  sortedcontainers,
  valkey,
}:

buildPythonPackage (finalAttrs: {
  pname = "fakeredis";
  version = "2.35.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cunla";
    repo = "fakeredis-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-euhWKXFERpRoXX7G81ffAygt5e1mt7uy9Y9zAGacu38=";
  };

  build-system = [ hatchling ];

  dependencies = [
    redis
    sortedcontainers
  ];

  optional-dependencies = {
    lua = [ lupa ];
    json = [ jsonpath-ng ];
    bf = [ pyprobables ];
    cf = [ pyprobables ];
    probabilistic = [ pyprobables ];
    valkey = [ valkey ];
    vectorset = [
      jsonpath-ng
      numpy
    ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    redisTestHook
    valkey
  ];

  pythonImportsCheck = [ "fakeredis" ];

  disabledTestMarks = [ "slow" ];

  disabledTests = [
    # redis.exceptions.ResponseError: unknown command 'evalsha'
    "test_async_lock"
  ];

  preCheck = ''
    redisTestPort=6390
  '';

  meta = {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/cunla/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
