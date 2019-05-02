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
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0axr4598b1h9kyb5mv104cpn5q667s0g1wkkbqzj66vrqsaa07qf";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

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
