{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  aws-error-utils,
  boto3,
}:

buildPythonPackage rec {
  pname = "aws-sso-lib";
  version = "1.14.0";
  pyproject = true;

  src = fetchPypi {
    pname = "aws_sso_lib";
    inherit version;
    hash = "sha256-sCA6ZMy2a6ePme89DrZpr/57wyP2q5yqyX81whoDzqU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    aws-error-utils
    boto3
  ];

  pythonImportsCheck = [
    "aws_sso_lib"
  ];

  meta = {
    description = "Library to make AWS SSO easier";
    homepage = "https://pypi.org/project/aws-sso-lib/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cterence ];
  };
}
