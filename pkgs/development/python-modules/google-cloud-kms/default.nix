{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, grpc_google_iam_v1
, google-api-core
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3aebe99c825e1be3bed937a8a6af056093872328b557745d966244abf7c54b13";
  };

  propagatedBuildInputs = [ grpc_google_iam_v1 google-api-core libcst proto-plus ];

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
