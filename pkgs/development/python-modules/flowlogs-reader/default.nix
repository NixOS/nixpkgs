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
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "obsrvbl";
    repo = pname;
    # https://github.com/obsrvbl/flowlogs-reader/issues/57
    rev = "refs/tags/v${version}";
    hash = "sha256-9UwCRLRKuIFRTh3ntAzlXCyN175J1wobT3GSLAhl+08=";
  };

  propagatedBuildInputs = [
    botocore
    boto3
    parquet
    python-dateutil
  ];

  nativeCheckInputs = [
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
