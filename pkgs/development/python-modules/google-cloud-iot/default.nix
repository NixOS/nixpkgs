{ lib
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, google-api-core
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-iot";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bccceae1f7c0efcefbcd1b5d67e56915d107534059843761831ba4e75e7884c5";
  };

  propagatedBuildInputs = [ grpc_google_iam_v1 google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_list_device_registries"
  ];

  pythonImportsCheck = [
    "google.cloud.iot"
    "google.cloud.iot_v1"
  ];

  meta = with lib; {
    description = "Cloud IoT API API client library";
    homepage = "https://github.com/googleapis/python-iot";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
