{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudevents,
  fastapi,
  grpc-interceptor,
  grpcio,
  grpcio-tools,
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
  six,
  tabulate,
  timing-asgi,
  uvicorn,

  # optional-dependencies
  # storage
  kserve-storage,
  # logging
  asgi-logger,
  # ray
  ray,
  # llm
  vllm,

  # tests
  avro,
  grpcio-testing,
  jinja2,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-httpx,
  pytest-xdist,
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "kserve";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kserve";
    repo = "kserve";
    tag = "v${version}";
    hash = "sha256-f6ILZMLxfckEpy7wSgCqUx89JWSnn0DbQiqRSHcQHms=";
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
    setuptools
  ];

  dependencies = [
    cloudevents
    fastapi
    grpc-interceptor
    grpcio
    grpcio-tools
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
  ]
  ++ uvicorn.optional-dependencies.standard;

  optional-dependencies = {
    storage = [
      kserve-storage
    ];
    logging = [
      asgi-logger
    ];
    ray = [
      ray
    ]
    ++ ray.optional-dependencies.serve;
    llm = [
      vllm
    ];
  };

  nativeCheckInputs = [
    avro
    grpcio-testing
    jinja2
    pytest-asyncio
    pytest-cov-stub
    pytest-httpx
    pytest-xdist
    pytestCheckHook
    tomlkit
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "kserve" ];

  disabledTestPaths = [
    # Looks for a config file at the root of the repository
    "test/test_inference_service_client.py"

    # AssertionError
    "test/test_server.py::TestTFHttpServerLoadAndUnLoad::test_unload"

    # Race condition when called concurrently between two instances of the same model (i.e. in nixpkgs-review)
    "test/test_dataplane.py::TestDataPlane::test_model_metadata[TEST_RAY_SERVE_MODEL]"
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
