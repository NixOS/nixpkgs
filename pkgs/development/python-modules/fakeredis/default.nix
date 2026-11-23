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
  version = "2.41.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cunla";
    repo = "fakeredis-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oY5DhpA7Umlp0MSjbxV530mY4wmIlgkOyBpqOm+SX3M=";
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
    # redis.exceptions.ResponseError: unknown command 'eval'
    "test_nested_replies_reach_the_client_intact"
  ];

  preCheck = ''
    redisTestPort=6390
  '';

  meta = {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/cunla/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
