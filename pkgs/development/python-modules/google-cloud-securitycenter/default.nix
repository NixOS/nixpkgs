{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  grpc-google-iam-v1,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-securitycenter";
  version = "1.35.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_securitycenter";
    inherit version;
    hash = "sha256-V9IRsInFIEuaNJKoCnl+PcFQHOCN1z6FPnD3113omx0=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-securitycenter";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-securitycenter-v${version}/packages/google-cloud-securitycenter/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
