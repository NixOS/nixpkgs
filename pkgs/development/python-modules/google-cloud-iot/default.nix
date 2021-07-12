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
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4d7c55636e8cb57a4dde41d933cd8663b1369ab3542b287957959ee59828559";
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
