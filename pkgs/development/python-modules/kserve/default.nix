{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  deprecation,
  poetry-core,

  # dependencies
  async-timeout,
  asgi-logger,
  cloudevents,
  fastapi,
  grpcio,
  httpx,
  azure-identity,
  kubernetes,
  numpy,
  orjson,
  pandas,
  prometheus-client,
  protobuf,
  requests,
  psutil,
  azure-storage-blob,
  azure-storage-file-share,
  boto3,
  google-cloud-storage,
  pydantic,
  python-dateutil,
  pyyaml,
  ray,
  six,
  tabulate,
  timing-asgi,
  uvicorn,

  # checks
  avro,
  grpcio-testing,
  pytest-asyncio,
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "kserve";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kserve";
    repo = "kserve";
    rev = "refs/tags/v${version}";
    hash = "sha256-wGS001PK+k21oCOaQCiAtytTDjfe0aiTVJ9spyOucYA=";
  };

  sourceRoot = "${src.name}/python/kserve";

  pythonRelaxDeps = [
    "fastapi"
    "httpx"
    "prometheus-client"
    "protobuf"
    "ray"
    "uvicorn"
    "psutil"
  ];

  build-system = [
    deprecation
    poetry-core
  ];

  dependencies = [
    async-timeout
    cloudevents
    fastapi
    grpcio
    httpx
    kubernetes
    numpy
    orjson
    pandas
    prometheus-client
    protobuf
    psutil
    pydantic
    python-dateutil
    pyyaml
    ray
    six
    tabulate
    timing-asgi
    uvicorn
  ] ++ ray.optional-dependencies.serve-deps;

  optional-dependencies = {
    storage = [
      azure-identity
      azure-storage-blob
      azure-storage-file-share
      boto3
      google-cloud-storage
      requests
    ];
    logging = [ asgi-logger ];
    ray = [ ray ];
  };

  nativeCheckInputs = [
    avro
    grpcio-testing
    pytest-asyncio
    pytestCheckHook
    tomlkit
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "kserve" ];

  disabledTestPaths = [
    # Looks for a config file at the root of the repository
    "test/test_inference_service_client.py"
  ];

  disabledTests = [
    # Require network access
    "test_health_handler"
    "test_infer"
    "test_infer_v2"
    # Assertion error due to HTTP response code
    "test_unload"
  ];

  meta = {
    description = "Standardized Serverless ML Inference Platform on Kubernetes";
    homepage = "https://github.com/kserve/kserve/tree/master/python/kserve";
    changelog = "https://github.com/kserve/kserve/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
