{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-cloud-core
, google-api-core
, grpc-google-iam-v1
, proto-plus
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a88f21b7a110dc9b5fd8e5bc9c07330fafc9ef150921505250aec0f0b25cf5e8";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core grpc-google-iam-v1 proto-plus ];

  checkInputs = [ mock pytestCheckHook ];

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
