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
  version = "1.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6b67545a87ec1e276bd5bf06abcc84332c4eb9dfa2fd415113e07a908fe55bb";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    boto3
    jsonschema
    six
  ] ++ lib.optionals (pythonOlder "3.4") [ enum34 ];

  meta = {
    homepage = "https://github.com/awslabs/serverless-application-model";
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.andreabedini ];
  };
}
