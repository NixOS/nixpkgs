{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  grpc-google-iam-v1,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-iam-logging";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_iam_logging";
    inherit (finalAttrs) version;
    hash = "sha256-p0PEXDzdq+DX88rW7mN9FBK7Nkhi01xubH+qeECr1d4=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.iam_logging"
    "google.cloud.iam_logging_v1"
  ];

  meta = {
    description = "IAM Service Logging client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-iam-logging";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-iam-logging-v${finalAttrs.version}/packages/google-cloud-iam-logging/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
