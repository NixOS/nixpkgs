{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "2.16.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nx3HL5FFrzI+ioE8jlA4DmrEvWpdvNQtzzFi2PN+UIA=";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.secretmanager"
    "google.cloud.secretmanager_v1"
    "google.cloud.secretmanager_v1beta1"
  ];

  meta = with lib; {
    description = "Secret Manager API API client library";
    homepage = "https://github.com/googleapis/python-secret-manager";
    changelog = "https://github.com/googleapis/python-secret-manager/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
