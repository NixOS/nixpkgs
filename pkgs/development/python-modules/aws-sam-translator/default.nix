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
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1008d149599d5d629b0c7bdfaa249d59eaab6d194faf5f0f941fa7209e68e6f2";
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
