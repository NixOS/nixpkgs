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
  version = "1.37.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p2qd8gwxsfq17nmrlkpf31aqbfzjrwjk3n4p8vhci8mm11dk138";
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
