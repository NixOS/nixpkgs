{ lib, buildPythonPackage, fetchPypi, google-api-core, libcst, mock, proto-plus, pytestCheckHook, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-os-config";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i4STXwnFyfXauRx4zvYMO1uWMechvNUOxolOcY3Z5us=";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [ "google.cloud.osconfig" ];

  disabledTests = [
    "test_patch_deployment"
    "test_patch_job"
  ];

  meta = with lib; {
    description = "Google Cloud OS Config API client library";
    homepage = "https://github.com/googleapis/python-os-config";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
