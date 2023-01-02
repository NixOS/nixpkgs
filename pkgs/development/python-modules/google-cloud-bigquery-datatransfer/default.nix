{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "3.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TR41fn/e4185RW8zkd3SY1E/jNQZuUYJr1n+TwNPHT4=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
    protobuf
    pytz
  ] ++ google-api-core.optional-dependencies.grpc;

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery_datatransfer"
    "google.cloud.bigquery_datatransfer_v1"
  ];

  meta = with lib; {
    description = "BigQuery Data Transfer API client library";
    homepage = "https://github.com/googleapis/python-bigquery-datatransfer";
    changelog = "https://github.com/googleapis/python-bigquery-datatransfer/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
