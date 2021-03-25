{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, mock
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-dataproc";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09e53889a60d84a71c505fe77174d242f00f28f989977aea91f6005cadfa466b";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.dataproc"
    "google.cloud.dataproc_v1"
    "google.cloud.dataproc_v1beta2"
  ];

  meta = with lib; {
    description = "Google Cloud Dataproc API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
