{ lib
, boto3
, botocore
, buildPythonPackage
, fetchFromGitHub
, parquet
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flowlogs-reader";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "obsrvbl";
    repo = pname;
    # https://github.com/obsrvbl/flowlogs-reader/issues/57
    rev = "fac4c6c63348ff67fd0a8f51d391ba7c9f59e5ed";
    hash = "sha256-bGb2CLp33aIr0R/lBPWAF3CbtVTWpqmcvYgZ6bcARTc=";
  };

  propagatedBuildInputs = [
    botocore
    boto3
    parquet
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flowlogs_reader"
  ];

  meta = with lib; {
    description = "Python library to make retrieving Amazon VPC Flow Logs from CloudWatch Logs a bit easier";
    homepage = "https://github.com/obsrvbl/flowlogs-reader";
    license = licenses.asl20;
    maintainers = with maintainers; [ cransom ];
  };
}
