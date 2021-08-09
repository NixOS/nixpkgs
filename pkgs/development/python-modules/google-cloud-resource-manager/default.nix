{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-cloud-core
, google-api-core
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5njC5yO7NTU81i9vmJoe1RBYPS1fU/3K5tgH7twyT+I=";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core ];

  checkInputs = [ mock pytestCheckHook ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud.resource_manager" ];

  meta = with lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = "https://github.com/googleapis/python-resource-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
