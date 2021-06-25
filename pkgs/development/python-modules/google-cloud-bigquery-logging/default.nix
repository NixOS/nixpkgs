{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc_google_iam_v1
, mock
, proto-plus
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-logging";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s8vlw157z10yzzkrfyzfl31iad96wfl3ywk9g3gmmh0jfgy0gfj";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc_google_iam_v1
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery_logging"
    "google.cloud.bigquery_logging_v1"
  ];

  meta = with lib; {
    description = "Bigquery logging client library";
    homepage = "https://github.com/googleapis/python-bigquery-logging";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
