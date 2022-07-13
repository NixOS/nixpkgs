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
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XfF4+F4+LmRyxn8Zs3gI2RegFb3Y+uoAinEqcLeWCGM=";
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
