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
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.25.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xQ1nt8FcjuoilzM5PbU8KHgirPyj9us+ykyjfgEqZhg=";
  };

  doCheck = false;

  pythonImportsCheck = [ "sagemaker" ];

  propagatedBuildInputs = [
    attrs
    boto3
    google-pasta
    importlib-metadata
    numpy
    protobuf
    protobuf3-to-dict
    smdebug-rulesconfig
  ];

  meta = with lib; {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
