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
  version = "1.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a3fd8e48a745967e8457b9cefdc3ad0f139ac4a25af4db9c13a9e1c19ea6910";
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
