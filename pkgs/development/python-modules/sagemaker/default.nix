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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.95.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rx4PrQqWN6Q19ov9Ao5sAGvdgls+y6WjMxP+35dpKsQ=";
  };

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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "attrs==20.3.0" "attrs>=20.3.0"
  '';

  postFixup = ''
    [ "$($out/bin/sagemaker-upgrade-v2 --help 2>&1 | grep -cim1 'pandas failed to import')" -eq "0" ]
  '';

  doCheck = false;

  pythonImportsCheck = [
    "sagemaker"
    "sagemaker.lineage.visualizer"
  ];

  meta = with lib; {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
