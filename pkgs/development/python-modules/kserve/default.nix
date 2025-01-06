{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  deprecation,
  poetry-core,

  # dependencies
  cloudevents,
  fastapi,
  grpcio,
  httpx,
  kubernetes,
  numpy,
  orjson,
  pandas,
  uvicorn,

  # optional-dependencies
  azure-identity,
  azure-storage-blob,
  azure-storage-file-share,
  boto3,
  google-cloud-storage,
  huggingface-hub,
  asgi-logger,
  ray,

  prometheus-client,
  protobuf,
  requests,
  psutil,
  pydantic,
  python-dateutil,
  pyyaml,
  six,
  tabulate,
  timing-asgi,

  # tests
  avro,
  grpcio-testing,
  pytest-asyncio,
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "kserve";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kserve";
    repo = "kserve";
    tag = "v${version}";
    hash = "sha256-VwuUXANjshV4fN0i54Fs0zubHY81UtQcCV14JwMpXwA=";
  };

  sourceRoot = "${src.name}/python/kserve";

  pythonRelaxDeps = [
    "fastapi"
    "httpx"
    "numpy"
    "prometheus-client"
    "protobuf"
    "uvicorn"
    "psutil"
  ];

  build-system = [
    deprecation
    poetry-core
  ];

  dependencies = [
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
    six
    tabulate
    timing-asgi
    uvicorn
  ];

  optional-dependencies = {
    storage = [
      azure-identity
      azure-storage-blob
      azure-storage-file-share
      boto3
      huggingface-hub
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
    "test_infer_graph_endpoint"
    "test_infer_path_based_routing"

    # Tries to access `/tmp` (hardcoded)
    "test_local_path_with_out_dir_exist"
  ];

  meta = {
    description = "Standardized Serverless ML Inference Platform on Kubernetes";
    homepage = "https://github.com/kserve/kserve/tree/master/python/kserve";
    changelog = "https://github.com/kserve/kserve/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
