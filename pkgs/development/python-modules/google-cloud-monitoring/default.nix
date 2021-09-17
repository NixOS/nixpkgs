{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-testutils
, libcst
, proto-plus
, pandas
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3d436fab7f50f69bdd47655871ac923e4dcbaf8538808bbe31cf0a3cbdf3514";
  };

  propagatedBuildInputs = [ libcst google-api-core proto-plus ];

  checkInputs = [ google-cloud-testutils mock pandas pytestCheckHook pytest-asyncio ];

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
    homepage = "https://github.com/googleapis/python-monitoring";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
