{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  attrs,
  boto3,
  cloudpickle,
  docker,
  google-pasta,
  importlib-metadata,
  jsonschema,
  numpy,
  packaging,
  pandas,
  pathos,
  platformdirs,
  protobuf,
  psutil,
  pyyaml,
  requests,
  sagemaker-core,
  sagemaker-mlflow,
  schema,
  smdebug-rulesconfig,
  tblib,
  tqdm,
  urllib3,

  # optional-dependencies
  scipy,
  accelerate,
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.232.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-q0JxQi1kUnp5L/hexxpGhR4t0v53l8iVuc9H6N0K6Y4=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "boto3"
    "cloudpickle"
    "importlib-metadata"
    "protobuf"
  ];

  dependencies = [
    attrs
    boto3
    cloudpickle
    docker
    google-pasta
    importlib-metadata
    jsonschema
    numpy
    packaging
    pandas
    pathos
    platformdirs
    protobuf
    psutil
    pyyaml
    requests
    sagemaker-core
    sagemaker-mlflow
    schema
    smdebug-rulesconfig
    tblib
    tqdm
    urllib3
  ];

  doCheck = false; # many test dependencies are not available in nixpkgs

  pythonImportsCheck = [
    "sagemaker"
    "sagemaker.lineage.visualizer"
  ];

  optional-dependencies = {
    local = [
      urllib3
      docker
      pyyaml
    ];
    scipy = [ scipy ];
    huggingface = [ accelerate ];
    # feature-processor = [ pyspark sagemaker-feature-store-pyspark ]; # not available in nixpkgs
  };

  meta = {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    changelog = "https://github.com/aws/sagemaker-python-sdk/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nequissimus ];
  };
}
