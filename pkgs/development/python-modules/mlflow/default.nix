{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  alembic,
  cachetools,
  click,
  cloudpickle,
  cryptography,
  databricks-sdk,
  docker,
  fastapi,
  flask,
  flask-cors,
  gitpython,
  graphene,
  gunicorn,
  huey,
  importlib-metadata,
  jinja2,
  markdown,
  matplotlib,
  numpy,
  opentelemetry-api,
  opentelemetry-proto,
  opentelemetry-sdk,
  packaging,
  pandas,
  protobuf,
  pyarrow,
  pydantic,
  python-dotenv,
  pyyaml,
  requests,
  scikit-learn,
  scipy,
  shap,
  skops,
  sqlalchemy,
  sqlparse,
  starlette,
  uvicorn,

  # tests
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
  pyspark,
  pytestCheckHook,
  pytorch-lightning,
  sentence-transformers,
  statsmodels,
  tensorflow,
  torch,
  transformers,
  xgboost,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlflow";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlflow";
    repo = "mlflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OxhM+KCem0sb9cwtyzrUD/MGfoiiCfgU47qipYRDaFk=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "gunicorn"
    "importlib_metadata"
    "packaging"
    "protobuf"
    "pytz"
    "pyarrow"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    alembic
    cachetools
    click
    cloudpickle
    cryptography
    databricks-sdk
    docker
    fastapi
    flask
    flask-cors
    gitpython
    graphene
    gunicorn
    huey
    importlib-metadata
    jinja2
    markdown
    matplotlib
    numpy
    opentelemetry-api
    opentelemetry-proto
    opentelemetry-sdk
    packaging
    pandas
    protobuf
    pyarrow
    pydantic
    python-dotenv
    pyyaml
    requests
    scikit-learn
    scipy
    shap
    skops
    sqlalchemy
    sqlparse
    starlette
    uvicorn
  ];

  pythonImportsCheck = [ "mlflow" ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/mlflow/mlflow/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
