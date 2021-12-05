{ lib, buildPythonPackage, fetchPypi, google-api-core, libcst, proto-plus
, pytestCheckHook, pytest-asyncio, pytz, mock }:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fdc8cb68a3ee54780f673f06b3cce83a5bb5d600db7ad363c85e38bf45afb59c";
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
