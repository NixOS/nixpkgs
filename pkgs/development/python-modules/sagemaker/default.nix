{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
  pythonRelaxDepsHook,
  setuptools,
  attrs,
  boto3,
  cloudpickle,
  google-pasta,
  numpy,
  protobuf,
  smdebug-rulesconfig,
  importlib-metadata,
  packaging,
  pandas,
  pathos,
  schema,
  pyyaml,
  jsonschema,
  platformdirs,
  tblib,
  urllib3,
  requests,
  docker,
  tqdm,
  psutil,
  scipy,
  accelerate,
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.219.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-TZpRRkoAlXU+Ccgxq49t+Cz0JOIUvYp7ok3x3sphncE=";
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
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cloudpickle"
    "importlib-metadata"
  ];

  dependencies = [
    attrs
    boto3
    cloudpickle
    google-pasta
    numpy
    protobuf
    smdebug-rulesconfig
    importlib-metadata
    packaging
    pandas
    pathos
    schema
    pyyaml
    jsonschema
    platformdirs
    tblib
    urllib3
    requests
    docker
    tqdm
    psutil
  ];

  doCheck = false; # many test dependencies are not available in nixpkgs

  pythonImportsCheck = [
    "sagemaker"
    "sagemaker.lineage.visualizer"
  ];

  passthru.optional-dependencies = {
    local = [
      urllib3
      docker
      pyyaml
    ];
    scipy = [ scipy ];
    huggingface = [ accelerate ];
    # feature-processor = [ pyspark sagemaker-feature-store-pyspark ]; # not available in nixpkgs
  };

  meta = with lib; {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    changelog = "https://github.com/aws/sagemaker-python-sdk/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
