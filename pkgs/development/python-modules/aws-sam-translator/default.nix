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
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ic9c2smfwp7sm0ahbzvihq3h1snabigfrc4pqv96v21iw5llv2g";
  };

  propagatedBuildInputs = [
    boto3
    jsonschema
    six
  ] ++ lib.optionals (pythonOlder "3.4") [ enum34 ];

  # infinite recusion cnf-lint depends on aws-sam-translator
  doCheck = false;

  meta = {
    homepage = https://github.com/awslabs/serverless-application-model;
    description = "Python library to transform SAM templates into AWS CloudFormation templates";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.andreabedini ];
  };
}
