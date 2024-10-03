{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  version = "2.232.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-I+iZKx1CnZIGYgYuYhhs8BnY84KPyKOGw8M0He26DGU=";
  };

  patches = [
    # Distutils removal, fix build with python 3.12
    # https://github.com/aws/sagemaker-python-sdk/pull/4544
    (fetchpatch {
      url = "https://github.com/aws/sagemaker-python-sdk/commit/84447ba59e544c810aeb842fd058e20d89e3fc74.patch";
      hash = "sha256-B8Q18ViB7xYy1F5LoL1NvXj2lnFPgt+C9wssSODyAXM=";
    })
    (fetchpatch {
      url = "https://github.com/aws/sagemaker-python-sdk/commit/e9e08a30cb42d4b2d7299c1c4b42d680a8c78110.patch";
      hash = "sha256-uGPtXSXfeaIvt9kkZZKQDuiZfoRgw3teffuxai1kKlY=";
    })
  ];

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "boto3"
    "cloudpickle"
    "importlib-metadata"
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
