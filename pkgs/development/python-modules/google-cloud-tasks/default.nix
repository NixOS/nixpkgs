{ lib, buildPythonPackage, fetchPypi, google-api-core, grpc-google-iam-v1
, libcst, mock, proto-plus, pytestCheckHook, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-tasks";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fd2222901a7d8ba65f28f9019cb41f5d4c952d012f020bdde105527a3f5ae43";
  };

  propagatedBuildInputs =
    [ google-api-core grpc-google-iam-v1 libcst proto-plus ];

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
