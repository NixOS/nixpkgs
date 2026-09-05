{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  hatchling,

  tomli,
  exceptiongroup,

  httpx,
  requests,
  dirty-equals,
  websockets,
  websocket-client,
  redis,
  aiohttp,
  psycopg2-binary,
  asyncpg,
  boto3,
  pika,
  celery,
  pymemcache,
  pymongo,
  pyjwt,
  cryptography,
  elasticsearch,
  paramiko,
  mcp,

  pytestCheckHook,
  pytest-asyncio,
  pytest-grpc,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-tripwire";
  version = "0.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "axiomantic";
    repo = "pytest-tripwire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AJqenh2m1h54Xk1C88a81f7qTg3yr86Korpquy4sF1g=";
  };

  build-system = [ hatchling ];
  dependencies = [
    tomli
    exceptiongroup
  ];

  pythonImportsCheck = [ "tripwire" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-grpc
  ]
  ++ (lib.flatten (lib.attrValues finalAttrs.passthru.optional-dependencies));

  disabledTests = [
    "test_resolve_patches_resolver_instance"
    "test_install_patches_with_handle_request_keeps_server_patch"
    "test_import_tripwire_resolves"
  ];

  passthru.optional-dependencies = {
    http = [
      httpx
      requests
    ];

    matchers = [ dirty-equals ];

    websockets = [
      websockets
      websocket-client
    ];

    redis = [ redis ];
    aiohttp = [ aiohttp ];
    psycopg2 = [ psycopg2-binary ];
    asyncpg = [ asyncpg ];
    boto3 = [ boto3 ];
    pika = [ pika ];
    celery = [ celery ];
    pymemcache = [ pymemcache ];
    pymongo = [ pymongo ];
    jwt = [ pyjwt ];
    crypto = [ cryptography ];
    elasticsearch = [ elasticsearch ];
    paramiko = [ paramiko ];
    mcp = [ mcp ];
  };

  meta = {
    description = "Pytest plugin for full-certainty test mocking";
    homepage = "https://github.com/axiomantic/pytest-tripwire";
    changelog = "https://github.com/axiomantic/pytest-tripwire/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
