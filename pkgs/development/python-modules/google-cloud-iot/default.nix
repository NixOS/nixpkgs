{ lib
, buildPythonPackage
, fetchPypi
, grpc-google-iam-v1
, google-api-core
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-iot";
  version = "2.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d3RRVqgetOS3sAT6UkV5DB/NZMjeZd5tBtd9ME8Wvs4=";
  };

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    libcst
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

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
