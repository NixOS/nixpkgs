{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  parquet,
  pytestCheckHook,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "flowlogs-reader";
  version = "5.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "obsrvbl";
    repo = "flowlogs-reader";
    # https://github.com/obsrvbl/flowlogs-reader/issues/57
    tag = "v${version}";
    hash = "sha256-9UwCRLRKuIFRTh3ntAzlXCyN175J1wobT3GSLAhl+08=";
  };

  propagatedBuildInputs = [
    botocore
    boto3
    parquet
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flowlogs_reader" ];

  meta = {
    description = "Python library to make retrieving Amazon VPC Flow Logs from CloudWatch Logs a bit easier";
    mainProgram = "flowlogs_reader";
    homepage = "https://github.com/obsrvbl/flowlogs-reader";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cransom ];
  };
}
