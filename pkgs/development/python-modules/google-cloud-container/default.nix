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
  pname = "google-cloud-container";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7d93ca399dd6fb5fd0f99190248531c9c583d1a85e7cd2c9ee485495459ee78";
  };

  propagatedBuildInputs = [ google-api-core grpc_google_iam_v1 libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.container"
    "google.cloud.container_v1"
    "google.cloud.container_v1beta1"
  ];

  meta = with lib; {
    description = "Google Container Engine API client library";
    homepage = "https://github.com/googleapis/python-container";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
