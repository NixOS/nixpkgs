{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5669410018eb41cecf6f9c90136d24d0ca9ed141bda8fbb3d52cd3de7162960";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];
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
