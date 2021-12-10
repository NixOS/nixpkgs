{ lib
, buildPythonPackage
, fetchFromGitHub
, google-api-core
, grpc-google-iam-v1
, mock
, proto-plus
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-logging";
  version = "1.0.1";

  src = fetchFromGitHub {
     owner = "googleapis";
     repo = "python-bigquery-logging";
     rev = "v1.0.1";
     sha256 = "1nnp1wjgjw8d3lkwsz23nl2w0d6233mx3klb5qhjnsd59gwyvi4w";
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
