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
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1syubhGCY8sYgV2mdneAV/8YOdplf5YZNEeZ0RAJC6E=";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus pytz ];
  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

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
