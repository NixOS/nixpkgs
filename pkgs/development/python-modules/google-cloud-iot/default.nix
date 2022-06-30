{ lib
, buildPythonPackage
, fetchPypi
, grpc-google-iam-v1
, google-api-core
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-iot";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y71v505bwXEV1u28WFAHs12Qx0tKY7BDjFCc+oBgZcw=";
  };

  propagatedBuildInputs = [ grpc-google-iam-v1 google-api-core libcst proto-plus ];

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
