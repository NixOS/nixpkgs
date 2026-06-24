{
  lib,
  aiohttp,
  aiosqlite,
  asyncpg,
  boto3,
  buildPythonPackage,
  cryptography,
  docker,
  e2b-code-interpreter,
  e2b,
  fastapi,
  fetchPypi,
  graphviz,
  griffelib,
  hatchling,
  inline-snapshot,
  litellm,
  mcp,
  numpy,
  openai,
  pydantic,
  pymongo,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  redis,
  requests,
  sqlalchemy,
  temporalio,
  textual,
  types-requests,
  typing-extensions,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai-agents";
  version = "0.17.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "openai_agents";
    hash = "sha256-avmv1LQN4jSTyasoXCjNTo/QiCQK9uluLe5FgmrVaP0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    griffelib
    mcp
    openai
    pydantic
    requests
    types-requests
    typing-extensions
  ];

  optional-dependencies = {
    voice = [
      numpy
      websockets
    ];
    viz = [ graphviz ];
    litellm = [ litellm ];
    realtime = [ websockets ];
    sqlalchemy = [
      asyncpg
      sqlalchemy
    ];
    encrypt = [ cryptography ];
    redis = [ redis ];
    mongodb = [ pymongo ];
    docker = [ docker ];
    cloudflare = [ aiohttp ];
    e2b = [
      e2b
      e2b-code-interpreter
    ];
    s3 = [ boto3 ];
    temporal = [
      temporalio
      textual
    ];
  };

  nativeCheckInputs = [
    aiosqlite
    fastapi
    inline-snapshot
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "agents" ];

  disabledTestPaths = [
    # Missing dependencies
    "tests/extensions/sandbox/test_runloop_capabilities_example.py"
    "tests/sandbox/integration_tests/test_runner_pause_resume.py"
    "tests/extensions/memory/test_redis_session.py"
    "tests/sandbox/test_runtime.py"
  ];

  disabledTests = [
    # AssertionError
    "test_runloop_extension_re_exports_cloud_bucket_strategy"
  ];

  meta = {
    description = "Lightweight, powerful framework for multi-agent workflows";
    homepage = "https://github.com/openai/openai-agents-python";
    changelog = "https://github.com/openai/openai-agents-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bryanhonof ];
  };
})
