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

buildPythonPackage rec {
  pname = "google-cloud-appengine-logging";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_appengine_logging";
    inherit version;
    hash = "sha256-/zl/C7wUhfl5q0V2fDjg9nbJWYyXw4T3QSIW5uoi+AU=";
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
    "google.cloud.appengine_logging"
    "google.cloud.appengine_logging_v1"
  ];

  meta = {
    description = "Appengine logging client library";
    homepage = "https://github.com/googleapis/python-appengine-logging";
    changelog = "https://github.com/googleapis/python-appengine-logging/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
