{ lib
, buildPythonPackage
, fetchPypi
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
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.59.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6tNUI08Fp2zITH1ILfVVEU0VhgvLogWfXPr9dkAKQEk=";
  };

  pythonImportsCheck = [
    "sagemaker"
    "sagemaker.lineage.visualizer"
  ];

  propagatedBuildInputs = [
    attrs
    boto3
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

  doCheck = false;

  postFixup = ''
    [ "$($out/bin/sagemaker-upgrade-v2 --help 2>&1 | grep -cim1 'pandas failed to import')" -eq "0" ]
  '';

  meta = with lib; {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
