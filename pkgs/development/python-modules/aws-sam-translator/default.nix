{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, boto3
, enum34
, jsonschema
, six
}:

buildPythonPackage rec {
  pname = "aws-sam-translator";
  version = "1.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d8a25e058c78d2cef5c07aec7f98cbc2070dbfc2eb6a2e102a16beafd14e3ca";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  disabled = isPy3k;

  propagatedBuildInputs = [
    boto3
    enum34
    jsonschema
    six
  ];

  meta = {
    homepage = https://github.com/awslabs/serverless-application-model;
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.andreabedini ];
  };
}
