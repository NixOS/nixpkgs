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
  version = "1.35.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cf7faab3566843f3b44ef1a42a9c106ffb50809da4002faab818076dcc7bff8";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    boto3
    jsonschema
    six
  ] ++ lib.optionals (pythonOlder "3.4") [ enum34 ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/serverless-application-model";
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    license = licenses.asl20;
  };
}
