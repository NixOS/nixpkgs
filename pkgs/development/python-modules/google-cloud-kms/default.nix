{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, grpc-google-iam-v1
, google-api-core
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ccf90b2a14098258648364dc16a0a58a3d281b8c7c6050fb9c05640c3809e7bb";
  };

  propagatedBuildInputs = [ grpc-google-iam-v1 google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  # Disable tests that need credentials
  disabledTests = [ "test_list_global_key_rings" ];

  pythonImportsCheck = [
    "google.cloud.kms"
    "google.cloud.kms_v1"
  ];

  meta = with lib; {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = "https://github.com/googleapis/python-kms";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
