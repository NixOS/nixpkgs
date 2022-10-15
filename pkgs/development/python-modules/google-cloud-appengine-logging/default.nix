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
  version = "1.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/zKQX6olZS0yl1yAu7Hguj87GUCiPfuf9oamobFHxjw=";
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
