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
  pythonAtLeast,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-firestore";
  version = "2.23.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_firestore";
    inherit (finalAttrs) version;
    hash = "sha256-qc/7p83GEBER1tVM3iLVIcmPnn1BXmdIaxN/oW8GqgM=";
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
    freezegun
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ]
  ++ lib.optionals (pythonOlder "3.14") [ aiounittest ];

  preCheck = ''
    # do not shadow imports
    rm -r google
  ''
  + lib.optionalString (pythonAtLeast "3.14") ''
    # aiounittest is not available for Python 3.14
    rm -r tests/unit/v1/test_bulk_writer.py
  '';

  disabledTestPaths = [
    # Tests are broken
    "tests/system/test_system.py"
    "tests/system/test_system_async.py"
    # Test requires credentials
    "tests/system/test_pipeline_acceptance.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: There is no current event loop in thread 'MainThread'
    # due to eliding aiounittest
    "tests/unit/v1/test_bundle.py::TestAsyncBundle::test_async_query"
  ];

  pythonImportsCheck = [
    "google.cloud.firestore_v1"
    "google.cloud.firestore_admin_v1"
  ];

  meta = {
    description = "Google Cloud Firestore API client library";
    homepage = "https://github.com/googleapis/python-firestore";
    changelog = "https://github.com/googleapis/python-firestore/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
