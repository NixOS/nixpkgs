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
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23160f717bd65de810fa538b7c145eae4384d10adb460e375d148de7f283bd10";
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
