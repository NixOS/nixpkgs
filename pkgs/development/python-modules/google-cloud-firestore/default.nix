{
  lib,
  aiounittest,
  buildPythonPackage,
  fetchPypi,
  freezegun,
  google-api-core,
  google-cloud-core,
  google-cloud-testutils,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-firestore";
  version = "2.21.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_firestore";
    inherit version;
    hash = "sha256-DDf6qFBil/gn7vw4/rFVJHpty5pUEoljEBXRJfGwA/g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    aiounittest
    freezegun
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    # do not shadow imports
    rm -r google
  '';

  disabledTestPaths = [
    # Tests are broken
    "tests/system/test_system.py"
    "tests/system/test_system_async.py"
    # Test requires credentials
    "tests/unit/v1/test_bulk_writer.py"
  ];

  disabledTests = [
    # Test requires credentials
    "test_collections"
  ];

  pythonImportsCheck = [
    "google.cloud.firestore_v1"
    "google.cloud.firestore_admin_v1"
  ];

  meta = with lib; {
    description = "Google Cloud Firestore API client library";
    homepage = "https://github.com/googleapis/python-firestore";
    changelog = "https://github.com/googleapis/python-firestore/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
