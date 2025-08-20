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
  fastapi,
  google-pasta,
  importlib-metadata,
  jsonschema,
  numpy,
  omegaconf,
  packaging,
  pandas,
  pathos,
  platformdirs,
  protobuf,
  psutil,
  pyyaml,
  requests,
  sagemaker-core,
  schema,
  smdebug-rulesconfig,
  tblib,
  tqdm,
  urllib3,
  uvicorn,

  # optional-dependencies
  scipy,
  accelerate,
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.237.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-python-sdk";
    tag = "v${version}";
    hash = "sha256-cNBPuXoViHy03ZMBrF3+xeMSUpovi1lloXizBvgNJmw=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "attrs"
    "boto3"
    "cloudpickle"
    "importlib-metadata"
    "numpy"
    "omegaconf"
    "protobuf"
  ];

  dependencies = [
    attrs
    boto3
    cloudpickle
    docker
    fastapi
    google-pasta
    importlib-metadata
    jsonschema
    numpy
    omegaconf
    packaging
    pandas
    pathos
    platformdirs
    protobuf
    psutil
    pyyaml
    requests
    sagemaker-core
    schema
    smdebug-rulesconfig
    tblib
    tqdm
    urllib3
    uvicorn
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
