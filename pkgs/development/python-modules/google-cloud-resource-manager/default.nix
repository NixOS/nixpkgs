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
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b13e0a614b4865287a4b5fc43f4810d3d48fef7e24d9bcf54cb4bd93bfbb2bf2";
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
