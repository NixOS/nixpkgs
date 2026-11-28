{
  lib,
  aiohttp,
  buildPythonPackage,
  cloudpickle,
  docker,
  docstring-parser,
  fastapi,
  fetchFromGitHub,
  google-cloud-bigquery-storage,
  google-cloud-bigquery,
  google-cloud-resource-manager,
  google-cloud-storage,
  google-genai,
  httpx,
  joblib,
  jsonschema,
  litellm,
  nix-update-script,
  numpy,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-sdk,
  packaging,
  pandas,
  pyarrow,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  requests-toolbelt,
  requests,
  setuptools,
  scikit-learn,
  starlette,
  tensorboard-plugin-profile,
  # tensorflow,
  tqdm,
  typing-extensions,
  urllib3,
  uvicorn,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-aiplatform";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-aiplatform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MUjrfnHWScRi3bZQhgXT04eqFXaQ4kFoJ4KHHeq6NHY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-cloud-bigquery
    google-cloud-resource-manager
    google-cloud-storage
    google-genai
  ];

  optional-dependencies = {
    profiler = [
      tensorboard-plugin-profile
      werkzeug
    ];
    tensorboard = [
      tensorboard-plugin-profile
      werkzeug
    ];
    metadata = [
      pandas
      numpy
    ];
    # xai = [ tensorflow ];  # tensorflow is broken
    featurestore = [
      google-cloud-bigquery-storage
      pandas
      pyarrow
    ];
    pipelines = [ pyyaml ];
    datasets = [ pyarrow ];
    # vizier = [ google-vizier ];
    prediction = [
      docker
      fastapi
      httpx
      starlette
      uvicorn
    ];
    endpoint = [
      requests
      requests-toolbelt
    ];
    private_endpoints = [
      urllib3
      requests
    ];
    genai_requires = [
      docstring-parser
      pydantic
      typing-extensions
    ];
    # adk = [
    #   google-adk
    #   aiohttp
    # ];
    agent_engines = [
      aiohttp
      cloudpickle
      opentelemetry-exporter-otlp-proto-http
      opentelemetry-sdk
      packaging
      pydantic
      typing-extensions
    ];
  };

  nativeCheckInputs = [
    joblib
    jsonschema
    litellm
    pyyaml
    pytest-asyncio
    pytestCheckHook
    scikit-learn
    tqdm
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # System tests require network access
    "tests/system/"
    "samples/"
    # Missing optional dependencies
    "tests/unit/vertex_ray/"
    "tests/unit/vertex_langchain/"
    "tests/unit/vertex_llama_index/"
    "tests/unit/vertex_adk/"
    "tests/unit/agentplatform/frameworks/"
    "tests/unit/agentplatform/genai/replays/"
    "tests/unit/agentplatform/genai/test_genai_model_garden.py"
    "tests/unit/aiplatform/test_prediction_security.py"
    "tests/unit/aiplatform/test_upload_tracker.py"
    "tests/unit/aiplatform/test_uploader_utils.py"
    "tests/unit/aiplatform/test_vision_models.py"
    "tests/unit/vertex_a2a/"
    "tests/unit/vertex_ag2/"
    "tests/unit/vertexai/test_autorater_yaml.py"
  ];

  disabledTests = [
    # IPython not available as a check dep
    "test_init_experiment_with_ipython_environment"
    # Architecture test assumes no internal modules leak into google.cloud namespace
    "test_vertexai_import"
    # pip3 not in the sandbox
    "test_packager_creates_and_copies_python_package"
    "test_requirements_are_in_package"
    "test_packaging_fails_whith_RuntimeError"
    "test_package_and_copy_to_gcs_copies_to_gcs"
    # PIL (Pillow) not available as a check dep
    "test_partstype_prompt_constructor"
    "test_partstype_prompt_assemble_contents"
  ];

  pythonImportsCheck = [ "google.cloud.aiplatform" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python SDK for Vertex AI";
    homepage = "https://github.com/googleapis/python-aiplatform";
    changelog = "https://github.com/googleapis/python-aiplatform/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
