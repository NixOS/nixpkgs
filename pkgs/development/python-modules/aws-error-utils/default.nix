{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  botocore,
}:

buildPythonPackage rec {
  pname = "aws-error-utils";
  version = "2.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "aws_error_utils";
    inherit version;
    hash = "sha256-BxB68qLCZwbNlSW3/77UPy0HtQ0n45+ekVbBGy6ZPJc=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    botocore
  ];

  pythonImportsCheck = [
    "aws_error_utils"
  ];

  meta = with lib; {
    description = "Error-handling functions for boto3/botocore";
    homepage = "https://pypi.org/project/aws-error-utils/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cterence ];
  };
}
