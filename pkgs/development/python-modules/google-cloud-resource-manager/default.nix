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
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OOxxazWbHSYyhHLDtKZIixzHUgsTZmxyyulfzh/TIrM=";
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
