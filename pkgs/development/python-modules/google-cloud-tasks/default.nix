{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc_google_iam_v1
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-tasks";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1038a1bb168adfdf1e65d5741b6d7e00f2ea48c5ef9e0a2c213e2972dba76ee";
  };

  propagatedBuildInputs = [ google-api-core grpc_google_iam_v1 libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_queues"
  ];

  pythonImportsCheck = [
    "google.cloud.tasks"
    "google.cloud.tasks_v2"
    "google.cloud.tasks_v2beta2"
    "google.cloud.tasks_v2beta3"
  ];

  meta = with lib; {
    description = "Cloud Tasks API API client library";
    homepage = "https://github.com/googleapis/python-tasks";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
