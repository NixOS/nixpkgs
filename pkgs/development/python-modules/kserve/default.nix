{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  deprecation,
  poetry-core,

  # dependencies
  cloudevents,
  fastapi,
  grpc-interceptor,
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
  vllm,

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
  pytest-httpx,
  pytest-xdist,
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "kserve";
  version = "0.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kserve";
    repo = "kserve";
    tag = "v${version}";
    hash = "sha256-NklR2Aoa5UdWkqNOfX+xl3R158JDSQtStXv9DkklOwM=";
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
    grpc-interceptor
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
    ]
    ++ huggingface-hub.optional-dependencies.hf_transfer;
    logging = [ asgi-logger ];
    ray = [ ray ];
    llm = [
      vllm
    ];
  };

  nativeCheckInputs = [
    avro
    grpcio-testing
    pytest-asyncio
    pytest-httpx
    pytest-xdist
    pytestCheckHook
    tomlkit
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "kserve" ];

  disabledTestPaths = [
    # Looks for a config file at the root of the repository
    "test/test_inference_service_client.py"

    # AssertionError
    "test/test_server.py::TestTFHttpServerLoadAndUnLoad::test_unload"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Failed to start GCS
    "test/test_dataplane.py::TestDataPlane::test_explain"
    "test/test_dataplane.py::TestDataPlane::test_infer"
    "test/test_dataplane.py::TestDataPlane::test_model_metadata"
    "test/test_dataplane.py::TestDataPlane::test_server_readiness"
    "test/test_server.py::TestRayServer::test_explain"
    "test/test_server.py::TestRayServer::test_health_handler"
    "test/test_server.py::TestRayServer::test_infer"
    "test/test_server.py::TestRayServer::test_list_handler"
    "test/test_server.py::TestRayServer::test_liveness_handler"
    "test/test_server.py::TestRayServer::test_predict"
    # Permission Error
    "test/test_server.py::TestMutiProcessServer::test_rest_server_multiprocess"
  ];

  disabledTests = [
    # AssertionError: assert CompletionReq...lm_xargs=None) == CompletionReq...lm_xargs=None)
    "test_convert_params"

    # Flaky: ray.exceptions.ActorDiedError: The actor died unexpectedly before finishing this task.
    "test_explain"
    "test_infer"
    "test_predict"

    # Require network access
    "test_infer_graph_endpoint"
    "test_infer_path_based_routing"

    # Tries to access `/tmp` (hardcoded)
    "test_local_path_with_out_dir_exist"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_local_path_with_out_dir_not_exist"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Standardized Serverless ML Inference Platform on Kubernetes";
    homepage = "https://github.com/kserve/kserve/tree/master/python/kserve";
    changelog = "https://github.com/kserve/kserve/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
