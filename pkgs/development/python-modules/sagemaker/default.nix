{ lib, buildPythonPackage, fetchPypi, attrs, boto3, google-pasta
, importlib-metadata, numpy, protobuf, protobuf3-to-dict, smdebug-rulesconfig }:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.24.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j1a058ic00yxnf0cc364fzn82pacih5ffrh5s4dw1q4s3by4cvd";
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
