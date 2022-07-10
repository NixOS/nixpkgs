{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-cloud-core
, google-api-core
, grpc-google-iam-v1
, proto-plus
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3lJfwntd6JdaU3/5MY8ZZuGc8iTt0Vfk6tVP8oWMtxQ=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.resourcemanager"
    "google.cloud.resourcemanager_v3"
  ];

  meta = with lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = "https://github.com/googleapis/python-resource-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
