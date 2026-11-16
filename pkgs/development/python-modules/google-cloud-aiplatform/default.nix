{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  google-api-core,
  google-auth,
  google-cloud-storage,
  google-cloud-bigquery,
  google-cloud-resource-manager,
  google-genai,
  docstring-parser,
  pydantic,
  proto-plus,
  protobuf,

  # optional-dependencies
  pandas,
  numpy,
  pyyaml,
  docker,
  fastapi,
  httpx2,
  tqdm,
  scikit-learn,
  jsonschema,
  ruamel-yaml,
  packaging,
  cloudpickle,
  opentelemetry-sdk,
  opentelemetry-exporter-otlp-proto-http,
  typing-extensions,
  aiohttp,
  google-adk,
  mlflow,
  xgboost,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-aiplatform";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-aiplatform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jgzMhwixn1Ub2wSWpl/HhkZTlZbjOvskaEPbjn+6tqQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    #     grpcio
    proto-plus
    protobuf
    pydantic
    google-cloud-storage
    google-cloud-resource-manager
    google-cloud-bigquery
    google-genai
    docstring-parser
  ];

  optional-dependencies = {
    metadata = [
      pandas
      numpy
    ];
    pipelines = [ pyyaml ];
    prediction = [
      docker
      fastapi
      httpx2
    ];
    evaluation = [
      pandas
      tqdm
      scikit-learn
      jsonschema
      ruamel-yaml
      pyyaml
      xgboost
    ];
    agent_engines = [
      packaging
      cloudpickle
      opentelemetry-sdk
      opentelemetry-exporter-otlp-proto-http
      pydantic
      typing-extensions
      aiohttp
    ];
    adk = [
      google-adk
      aiohttp
    ];
    autologging = [ mlflow ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  # Only pull in the light extras the selected tests need
  ++ finalAttrs.passthru.optional-dependencies.metadata
  ++ finalAttrs.passthru.optional-dependencies.pipelines
  ++ finalAttrs.passthru.optional-dependencies.prediction
  ++ [ aiohttp ];

  # The full unit test suite needs tensorflow, ray, mlflow, langchain, etc.
  # Run only the tests covering the core SDK surface.
  enabledTestPaths = [
    "tests/unit/aiplatform/test_base.py"
    "tests/unit/aiplatform/test_custom_job.py"
    "tests/unit/aiplatform/test_datasets.py"
    "tests/unit/aiplatform/test_endpoints.py"
    "tests/unit/aiplatform/test_helpers.py"
    "tests/unit/aiplatform/test_hyperparameter_tuning_job.py"
    "tests/unit/aiplatform/test_initializer.py"
    "tests/unit/aiplatform/test_jobs.py"
    "tests/unit/aiplatform/test_logging.py"
    "tests/unit/aiplatform/test_metadata_resources.py"
    "tests/unit/aiplatform/test_metadata_store.py"
    "tests/unit/aiplatform/test_models.py"
    "tests/unit/aiplatform/test_pipeline_jobs.py"
    "tests/unit/aiplatform/test_utils.py"
  ];

  disabledTests = [
    # Require pyarrow
    "test_create_dataset_tabular_from_dataframe"
    # Mocked Bucket.exists is never called
    "test_create_gcs_bucket_for_pipeline_artifacts_if_it_does_not_exist"
  ];

  pythonImportsCheck = [
    "google.cloud.aiplatform"
    "vertexai"
  ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
  };

  meta = {
    description = "A Python SDK for Vertex AI, a fully managed, end-to-end platform for data science and machine learning.";
    homepage = "https://github.com/googleapis/python-aiplatform";
    changelog = "https://github.com/googleapis/python-aiplatform/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dshatz ];
  };
})
