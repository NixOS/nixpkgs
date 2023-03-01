{ lib
, buildPythonPackage
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
, schema
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.135.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256:6688eef08ca8be1cc5f944d21ba81cd06dc78fbcfebbbb4ea780050e2644e02b";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "importlib-metadata>=1.4.0,<5.0" "importlib-metadata"
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    # FIXME: Remove when >= 2.111.0
    "attrs"
    "protobuf"
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
    schema
  ];

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
