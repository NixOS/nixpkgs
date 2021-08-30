{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, mock
, proto-plus
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-logging";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5ixj9MnJVVcU9NR4ZBe0TAp8ogJLAKrPlyGm5d/iQwA=";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
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
