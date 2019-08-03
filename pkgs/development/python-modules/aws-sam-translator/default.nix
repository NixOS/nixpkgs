{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, boto3
, enum34
, jsonschema
, six
}:

buildPythonPackage rec {
  pname = "aws-sam-translator";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db872c43bdfbbae9fc8c9201e6a7aeb9a661cda116a94708ab0577b46a38b962";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    boto3
    jsonschema
    six
  ] ++ lib.optionals (pythonOlder "3.4") [ enum34 ];

  meta = {
    homepage = https://github.com/awslabs/serverless-application-model;
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.andreabedini ];
  };
}
