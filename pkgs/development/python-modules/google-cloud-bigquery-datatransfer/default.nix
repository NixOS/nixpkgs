{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pytz
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "3.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oPgbgaq5RQM4C2qmf36i+qXDQA9sV16abCleNkdGYC0=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
    pytz
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery_datatransfer"
    "google.cloud.bigquery_datatransfer_v1"
  ];

  meta = with lib; {
    description = "BigQuery Data Transfer API client library";
    homepage = "https://github.com/googleapis/python-bigquery-datatransfer";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
