{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  deprecation,
  poetry-core,
  pythonRelaxDepsHook,
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
  python-dateutil,
  ray,
  six,
  tabulate,
  timing-asgi,
  uvicorn,
  avro,
  azure-storage-blob,
  azure-storage-file-share,
  boto3,
  botocore,
  google-cloud-storage,
  grpcio-testing,
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "kserve";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kserve";
    repo = "kserve";
    rev = "refs/tags/v${version}";
    hash = "sha256-Fu+1AR7FU4EQ+PhMneHFr3at3N9cN7V24wm/VOfY8GA=";
  };

  sourceRoot = "${src.name}/python/kserve";

  build-system = [
    deprecation
    poetry-core
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
    python-dateutil
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
