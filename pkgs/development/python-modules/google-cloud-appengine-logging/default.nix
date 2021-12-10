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
  pname = "google-cloud-appengine-logging";
  version = "1.1.0";

  src = fetchFromGitHub {
     owner = "googleapis";
     repo = "python-appengine-logging";
     rev = "v1.1.0";
     sha256 = "0awxfas34az5s4xhigjrhlhy88av9ybw12i80lfp9jlcwsmqzkz6";
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
    "google.cloud.appengine_logging"
    "google.cloud.appengine_logging_v1"
  ];

  meta = with lib; {
    description = "Appengine logging client library";
    homepage = "https://github.com/googleapis/python-appengine-logging";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
