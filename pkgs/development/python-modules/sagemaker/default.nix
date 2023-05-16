{ lib
, buildPythonPackage
<<<<<<< HEAD
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
=======
, fetchPypi
, pythonRelaxDepsHook
, attrs
, boto3
, google-pasta
, importlib-metadata
, numpy
, protobuf
, protobuf3-to-dict
, smdebug-rulesconfig
, pandas
, pathos
, packaging
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "sagemaker";
<<<<<<< HEAD
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
=======
  version = "2.135.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ypdcqEYLxHbfnq1ycq3hVLThhIIs3pq29Fv33Ly2hbE=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    # FIXME: Remove when >= 2.111.0
    "attrs"
    "protobuf"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    attrs
    boto3
<<<<<<< HEAD
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
=======
    google-pasta
    importlib-metadata
    numpy
    packaging
    pathos
    protobuf
    protobuf3-to-dict
    smdebug-rulesconfig
    pandas
  ];

  postFixup = ''
    [ "$($out/bin/sagemaker-upgrade-v2 --help 2>&1 | grep -cim1 'pandas failed to import')" -eq "0" ]
  '';

  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "sagemaker"
    "sagemaker.lineage.visualizer"
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    local = [ urllib3 docker pyyaml ];
    scipy = [ scipy ];
    # feature-processor = [ pyspark sagemaker-feature-store-pyspark ]; # not available in nixpkgs
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
