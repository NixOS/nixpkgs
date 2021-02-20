{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-testutils
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "639408cac9660b6c7c2324bf1b2461c9c8e338518b9ebb7ebfac833a61d753eb";
  };

  propagatedBuildInputs = [ libcst google-api-core proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_monitored_resource_descriptors"
  ];

  pythonImportsCheck = [
    "google.cloud.monitoring"
    "google.cloud.monitoring_v3"
  ];

  meta = with lib; {
    description = "Stackdriver Monitoring API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
