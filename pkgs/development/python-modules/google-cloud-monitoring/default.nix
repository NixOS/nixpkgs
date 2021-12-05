{ lib, buildPythonPackage, fetchPypi, google-api-core, google-cloud-testutils
, libcst, proto-plus, pandas, pytestCheckHook, pytest-asyncio, mock }:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "973f33f4da9598a30769e27510fc0cd4470f9081ba694c6c589bb8c0b86a0a6d";
  };

  propagatedBuildInputs = [ libcst google-api-core proto-plus ];

  checkInputs =
    [ google-cloud-testutils mock pandas pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_monitored_resource_descriptors"
  ];

  pythonImportsCheck =
    [ "google.cloud.monitoring" "google.cloud.monitoring_v3" ];

  meta = with lib; {
    description = "Stackdriver Monitoring API client library";
    homepage = "https://github.com/googleapis/python-monitoring";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
