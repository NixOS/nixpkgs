{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  gitUpdater,

  # dependencies
  google-api-core,
  google-auth,
  proto-plus,
  protobuf,
  packaging,
  google-cloud-storage,
  google-cloud-bigquery,
  google-cloud-resource-manager,
  shapely,

  # optional dependencies
  # NB: Commented-out dependencies are either currently missing from nixpkgs,
  # or only used in an optional extra which is currently missing another dependency.

  # absl-py,
  # cloudpickle,
  docker,
  docstring-parser,
  # explainable-ai-sdk,
  fastapi,
  google-cloud-bigquery-storage,
  # google-cloud-trace,
  # google-vizier,
  httpx,
  immutabledict,
  # langchain,
  # langchain-core,
  # langchain-google-vertexai,
  # lit-nlp,
  mlflow,
  nltk,
  numpy,
  # openinference-instrumentation-langchain,
  # opentelemetry-exporter-gcp-trace,
  # opentelemetry-sdk,
  pandas,
  pyarrow,
  pydantic,
  # pytest-xdist,
  pyyaml,
  ray,
  requests,
  # scikit-learn,
  sentencepiece,
  setuptools,
  starlette,
  tensorboard-plugin-profile,
  tensorflow,
  # torch,
  tqdm,
  urllib3,
  uvicorn,
  werkzeug,
# xgboost,
# xgboost_ray,
}:

buildPythonPackage rec {
  pname = "google-cloud-aiplatform";
  version = "1.73.0";

  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-aiplatform";
    rev = "refs/tags/v${version}";
    hash = "sha256-24NNMJ/m+VyEg/544GTCShFe1zGxel2fNkbFtwh0zfs=";
  };

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
    packaging
    google-cloud-storage
    google-cloud-bigquery
    google-cloud-resource-manager
    shapely
  ] ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = rec {

    profiler-deps = [
      tensorboard-plugin-profile
      werkzeug
      tensorflow
    ];

    tensorboard-deps = [ tensorflow ] ++ profiler-deps;

    metadata-deps = [
      pandas
      numpy
    ];

    xai-deps = [ tensorflow ];

    # lit-deps = [
    #   tensorflow
    #   pandas
    #   lit-nlp
    #   explainable-ai-sdk
    # ];

    featurestore-deps = [
      google-cloud-bigquery-storage
      pyarrow
    ];

    pipelines-deps = [ pyyaml ];

    datasets-deps = [ pyarrow ];

    # vizier-deps = [ google-vizier ];

    prediction-deps = [
      docker
      fastapi
      httpx
      starlette
      uvicorn
    ] ++ uvicorn.optional-dependencies.standard;

    endpoint-deps = [ requests ];

    private_endpoints-deps = [
      urllib3
      requests
    ];

    autologging-deps = [ mlflow ];

    preview-deps = [ ];

    ray-deps = [
      ray
      setuptools
      google-cloud-bigquery-storage
      google-cloud-bigquery
      pandas
      pyarrow
      immutabledict
    ];

    genai-deps = [
      pydantic
      docstring-parser
    ];

    # ray_testing-deps = ray-deps ++ [
    #     pytest-xdist
    #     ray
    #     scikit-learn
    #     tensorflow
    #     torch
    #     xgboost
    #     xgboost_ray
    # ];

    # reasoning_engine-deps = [
    #     cloudpickle
    #     google-cloud-trace
    #     opentelemetry-sdk
    #     opentelemetry-exporter-gcp-trace
    #     pydantic
    # ];

    evaluation-deps = [
      pandas
      tqdm
    ];

    # langchain-deps = [
    #   langchain
    #   langchain-core
    #   langchain-google-vertexai
    #   openinference-instrumentation-langchain
    # ];

    # langchain_testing-deps =
    #     langchain-deps
    #         ++ reasoning_engine-deps
    #         ++ [ absl-py pytest-xdist ];

    tokenization-deps = [ sentencepiece ];

    tokenization_testing-deps = tokenization-deps ++ [ nltk ];
  };

  pythonImportsCheck = [
    "google.cloud.aiplatform"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Gemini API and Generative AI on Vertex AI";
    downloadPage = "https://github.com/googleapis/python-aiplatform/releases/tag/v${version}";
    homepage = "https://github.com/googleapis/python-aiplatform";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
