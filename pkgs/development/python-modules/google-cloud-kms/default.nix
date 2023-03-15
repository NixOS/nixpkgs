{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "2.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/tm08lOWjQMjV1IVov8cX0EJsKjwxMQD2NIcJnoHdVc=";
  };

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # Disable tests that need credentials
  disabledTests = [
    "test_list_global_key_rings"
  ];

  pythonImportsCheck = [
    "google.cloud.kms"
    "google.cloud.kms_v1"
  ];

  meta = with lib; {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = "https://github.com/googleapis/python-kms";
    changelog = "https://github.com/googleapis/python-kms/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
