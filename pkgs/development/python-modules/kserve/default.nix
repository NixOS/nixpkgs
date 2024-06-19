{
  lib,
  buildPythonPackage,
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
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "kserve";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kserve";
    repo = "kserve";
    rev = "refs/tags/v${version}";
    hash = "sha256-gKJkG8zJY1sGGpI27YZ/QnEPU8J7KHva3nI+JCglQaQ=";
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

  meta = with lib; {
    description = "Standardized Serverless ML Inference Platform on Kubernetes";
    homepage = "https://github.com/kserve/kserve/tree/master/python/kserve";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
