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
  pname = "google-cloud-appengine-logging";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1E+3fXcGsIbTh7nXnBOcVT1UtY3cjulnu/MqU+e77lY=";
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
