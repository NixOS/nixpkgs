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
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e34d506596ebb6e285d8500342587e8ec0bd31924f290f1f39cc4ea2e4f1abfb";
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
