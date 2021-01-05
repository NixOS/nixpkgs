{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_testutils
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07r0y995fin6cbnqlhmd38fv3pfhhqyw04l7nr38sldrd82gmsqx";
  };

  propagatedBuildInputs = [ libcst google_api_core proto-plus ];

  checkInputs = [ google_cloud_testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_monitored_resource_descriptors"
  ];

  pythonImportsCheck = [
    "google.cloud.monitoring"
    "google.cloud.monitoring_v3"
  ];

  meta = with stdenv.lib; {
    description = "Stackdriver Monitoring API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
