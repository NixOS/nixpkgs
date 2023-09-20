{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pythonRelaxDepsHook
, attrs
, boto3
, cloudpickle
, google-pasta
, numpy
, protobuf
, smdebug-rulesconfig
, importlib-metadata
, packaging
, pandas
, pathos
, schema
, pyyaml
, jsonschema
, platformdirs
, tblib
, urllib3
, docker
, scipy
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.184.0.post0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-gQQsHJ9b5ZbbPW0nJRdudSwaL+Hc8kwBpK9um8QWQio=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "attrs"
    "boto3"
  ];

  propagatedBuildInputs = [
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
  ];

  doCheck = false; # many test dependencies are not available in nixpkgs

  pythonImportsCheck = [
    "sagemaker"
    "sagemaker.lineage.visualizer"
  ];

  passthru.optional-dependencies = {
    local = [ urllib3 docker pyyaml ];
    scipy = [ scipy ];
    # feature-processor = [ pyspark sagemaker-feature-store-pyspark ]; # not available in nixpkgs
  };

  meta = with lib; {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
