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
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.31.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RMw7l3s0QBzB+exiZg2aBQYeprHUJM+f0Rf+N8ywaBU=";
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
