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
  pname = "google-cloud-iam-logging";
  version = "1.0.0";

  src = fetchFromGitHub {
     owner = "googleapis";
     repo = "python-iam-logging";
     rev = "v1.0.0";
     sha256 = "1q2zzd4w3iwwfncfavzypfsx7qhn6lf43qr7fcsmnh8mhqxhg8v3";
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
    "google.cloud.iam_logging"
    "google.cloud.iam_logging_v1"
  ];

  meta = with lib; {
    description = "IAM Service Logging client library";
    homepage = "https://github.com/googleapis/python-iam-logging";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
