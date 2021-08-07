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
  pname = "google-cloud-appengine-logging";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rkayy2qzsc70b0rdvzd2bxwp5f07rfqb95cyj57dkphq71mrrhw";
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
