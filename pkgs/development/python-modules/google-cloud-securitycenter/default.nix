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
  pname = "google-cloud-securitycenter";
  version = "1.23.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8yBC/+jxKsyQ5pz+VBSgnwqB/XxXCChpjGLAjMDoQow=";
  };

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.securitycenter"
    "google.cloud.securitycenter_v1"
    "google.cloud.securitycenter_v1beta1"
    "google.cloud.securitycenter_v1p1beta1"
  ];

  meta = with lib; {
    description = "Cloud Security Command Center API API client library";
    homepage = "https://github.com/googleapis/python-securitycenter";
    changelog = "https://github.com/googleapis/python-securitycenter/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
