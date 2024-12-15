{
  lib,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  alembic,
  buildPythonPackage,
  cachetools,
  click,
  cloudpickle,
  databricks-sdk,
  docker,
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

  # tests
  aiohttp,
  azure-core,
  azure-storage-blob,
  azure-storage-file,
  boto3,
  botocore,
  catboost,
  datasets,
  fastapi,
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
  starlette,
  statsmodels,
  tensorflow,
  torch,
  transformers,
  uvicorn,
  xgboost,
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "2.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlflow";
    repo = "mlflow";
    rev = "refs/tags/v${version}";
    hash = "sha256-etfgdSf3pbcKtCOk9MOgcR+Tzg4cmLbdadAOtQqN4PM=";
  };

  # Remove currently broken dependency `shap`, a model explainability package.
  # This seems quite unprincipled especially with tests not being enabled,
  # but not mlflow has a 'skinny' install option which does not require `shap`.
  pythonRemoveDeps = [ "shap" ];
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
    databricks-sdk
    docker
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
    pyyaml
    requests
    scikit-learn
    scipy
    sqlalchemy
    sqlparse
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
    fastapi
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
    changelog = "https://github.com/mlflow/mlflow/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
