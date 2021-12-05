{ lib, buildPythonPackage, fetchPypi, google-api-core, libcst, mock, proto-plus
, pytestCheckHook, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-os-config";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "872774c4791b15d59d866fd965c780beac2772f335ded4a0047e2d844d988f30";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [ "google.cloud.osconfig" ];

  disabledTests = [ "test_patch_deployment" "test_patch_job" ];

  meta = with lib; {
    description = "Google Cloud OS Config API client library";
    homepage = "https://github.com/googleapis/python-os-config";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
