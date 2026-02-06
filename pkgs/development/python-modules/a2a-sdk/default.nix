{
  lib,
  aiosqlite,
  buildPythonPackage,
  cryptography,
  fastapi,
  fetchFromGitHub,
  google-api-core,
  grpcio-reflection,
  grpcio-tools,
  grpcio,
  hatchling,
  httpx-sse,
  httpx,
  opentelemetry-api,
  opentelemetry-sdk,
  protobuf,
  pydantic,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  respx,
  sqlalchemy,
  sse-starlette,
  starlette,
  uv-dynamic-versioning,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "a2a-sdk";
  version = "0.3.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "a2aproject";
    repo = "a2a-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RGD55BGxWSPJXKqDPcTYW3pIzlOVPoOqd3hyTArifqc=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    google-api-core
    httpx
    httpx-sse
    protobuf
    pydantic
  ];

  optional-dependencies = {
    encryption = [ cryptography ];
    grpc = [
      grpcio
      grpcio-reflection
      grpcio-tools
    ];
    http-server = [
      fastapi
      sse-starlette
      starlette
    ];
    mysql = [ sqlalchemy ];
    postgresql = [ sqlalchemy ];
    signing = [ pyjwt ];
    sqlite = [ sqlalchemy ];
    telemetry = [
      opentelemetry-api
      opentelemetry-sdk
    ];
  };

  nativeCheckInputs = [
    aiosqlite
    pytest-asyncio
    pytestCheckHook
    respx
    uvicorn
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "a2a" ];

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # _pickle.PicklingError: Can't pickle local object <function...
    "test_notification_triggering"
  ];

  meta = {
    description = "Python SDK for the Agent2Agent (A2A) Protocol";
    homepage = "https://github.com/a2aproject/a2a-python";
    changelog = "https://github.com/a2aproject/a2a-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
