{ stdenv
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
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hmsqvs2srmqcwmli48vd5vw829zax3pwj63fsxig6sdhjlf6j7j";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];
  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [
    "google.cloud.bigquery_datatransfer"
    "google.cloud.bigquery_datatransfer_v1"
  ];

  meta = with stdenv.lib; {
    description = "BigQuery Data Transfer API client library";
    homepage = "https://github.com/googleapis/python-bigquery-datatransfer";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
