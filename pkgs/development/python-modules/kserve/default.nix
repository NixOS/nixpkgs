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
  cloudevents,
  fastapi,
  grpcio,
  httpx,
  kubernetes,
  numpy,
  orjson,
  pandas,
  prometheus-client,
  protobuf,
  psutil,
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
  azure-storage-blob,
  azure-storage-file-share,
  boto3,
  botocore,
  google-cloud-storage,
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
  ] ++ ray.passthru.optional-dependencies.serve-deps;

  pythonRelaxDeps = [
    "fastapi"
    "httpx"
    "prometheus-client"
    "protobuf"
    "ray"
    "uvicorn"
    "psutil"
  ];

  pythonImportsCheck = [ "kserve" ];

  nativeCheckInputs = [
    avro
    azure-storage-blob
    azure-storage-file-share
    boto3
    botocore
    google-cloud-storage
    grpcio-testing
    pytest-asyncio
    pytestCheckHook
    tomlkit
  ];

  disabledTestPaths = [
    # Looks for a config file at the root of the repository
    "test/test_inference_service_client.py"
  ];

  disabledTests = [
    # Require network access
    "test_health_handler"
    "test_infer"
    "test_infer_v2"
  ];

  meta = {
    description = "Standardized Serverless ML Inference Platform on Kubernetes";
    homepage = "https://github.com/kserve/kserve/tree/master/python/kserve";
    changelog = "https://github.com/kserve/kserve/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
