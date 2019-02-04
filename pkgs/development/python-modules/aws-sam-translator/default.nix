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
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kfpdsvhsz2nx74p34b904mgn101z5h9451231sdaz07hmd7jd0k";
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
