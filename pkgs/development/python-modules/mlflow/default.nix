{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  alembic,
  cachetools,
  click,
  cloudpickle,
  cryptography,
  databricks-sdk,
  docker,
  fastapi,
  flask,
  gitpython,
  graphene,
  gunicorn,
  importlib-metadata,
  jinja2,
  markdown,
  matplotlib,
  numpy,
  opentelemetry-api,
  opentelemetry-sdk,
  packaging,
  pandas,
  protobuf,
  pyarrow,
  pyyaml,
  requests,
  scikit-learn,
  scipy,
  sqlalchemy,
  sqlparse,
  uvicorn,

  # tests
  aiohttp,
  azure-core,
  azure-storage-blob,
  azure-storage-file,
  boto3,
  botocore,
  catboost,
  datasets,
  google-cloud-storage,
  httpx,
  jwt,
  keras,
  langchain,
  librosa,
  moto,
  opentelemetry-exporter-otlp,
  optuna,
  pydantic,
  pyspark,
  pytestCheckHook,
  pytorch-lightning,
  sentence-transformers,
  shap,
  starlette,
  statsmodels,
  tensorflow,
  torch,
  transformers,
  xgboost,
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlflow";
    repo = "mlflow";
    tag = "v${version}";
    hash = "sha256-5zObSnGx7+cCrqRfvcnprQN05NqVBCeWcAZEE1Jpeuo=";
  };

  pythonRelaxDeps = [
    "gunicorn"
    "importlib-metadata"
    "packaging"
    "protobuf"
    "pytz"
    "pyarrow"
  ];

  build-system = [ setuptools ];

  dependencies = [
    alembic
    cachetools
    click
    cloudpickle
    cryptography
    databricks-sdk
    docker
    fastapi
    flask
    gitpython
    graphene
    gunicorn
    importlib-metadata
    jinja2
    markdown
    matplotlib
    numpy
    opentelemetry-api
    opentelemetry-sdk
    packaging
    pandas
    protobuf
    pyarrow
    pydantic
    pyyaml
    requests
    scikit-learn
    scipy
    shap
    sqlalchemy
    sqlparse
    uvicorn
  ];

  pythonImportsCheck = [ "mlflow" ];

  nativeCheckInputs = [
    aiohttp
    azure-core
    azure-storage-blob
    azure-storage-file
    boto3
    botocore
    catboost
    datasets
    google-cloud-storage
    httpx
    jwt
    keras
    langchain
    librosa
    moto
    opentelemetry-exporter-otlp
    optuna
    pydantic
    pyspark
    pytestCheckHook
    pytorch-lightning
    sentence-transformers
    starlette
    statsmodels
    tensorflow
    torch
    transformers
    uvicorn
    xgboost
  ];

  disabledTestPaths = [
    # Requires unpackaged `autogen`
    "tests/autogen/test_autogen_autolog.py"

    # Requires unpackaged `diviner`
    "tests/diviner/test_diviner_model_export.py"

    # Requires unpackaged `sktime`
    "examples/sktime/test_sktime_model_export.py"

    # Requires `fastai` which would cause a circular dependency
    "tests/fastai/test_fastai_autolog.py"
    "tests/fastai/test_fastai_model_export.py"

    # Requires `spacy` which would cause a circular dependency
    "tests/spacy/test_spacy_model_export.py"

    # Requires `tensorflow.keras` which is not included in our outdated version of `tensorflow` (2.13.0)
    "tests/gateway/providers/test_ai21labs.py"
    "tests/tensorflow/test_keras_model_export.py"
    "tests/tensorflow/test_keras_pyfunc_model_works_with_all_input_types.py"
    "tests/tensorflow/test_mlflow_callback.py"
  ];

  # I (@GaetanLepage) gave up at enabling tests:
  # - They require a lot of dependencies (some unpackaged);
  # - Many errors occur at collection time;
  # - Most (all ?) tests require internet access anyway.
  doCheck = false;

  meta = {
    description = "Open source platform for the machine learning lifecycle";
    mainProgram = "mlflow";
    homepage = "https://github.com/mlflow/mlflow";
    changelog = "https://github.com/mlflow/mlflow/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
