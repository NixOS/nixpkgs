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
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.126.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wuU53FmrtAY8E08Q+W4OhBoBQ8kks3LjJiR7kxlbfAg=";
  };

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
