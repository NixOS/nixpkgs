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
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-securitycenter";
  version = "1.48.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_securitycenter";
    inherit (finalAttrs) version;
    hash = "sha256-q0W0nlPsDpIpYYup7hkUOEhT3b1GQs8mEzhjO6PrXLU=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    grpc-google-iam-v1
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

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

  meta = {
    description = "Cloud Security Command Center API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-securitycenter";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-securitycenter-v${finalAttrs.version}/packages/google-cloud-securitycenter/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
