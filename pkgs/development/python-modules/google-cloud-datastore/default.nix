{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-core,
  google-cloud-testutils,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-datastore";
  version = "2.25.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_datastore";
    inherit (finalAttrs) version;
    hash = "sha256-3WRqPY+ZwnULtfbg8Y7Oe+2V/XbgLayt2/o1orIjKP8=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = [
    google-api-core
    google-cloud-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
    libcst = [ libcst ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # directory shadows imports
    rm -r google
  '';

  disabledTestPaths = [
    # Requires credentials
    "tests/system/test_aggregation_query.py"
    "tests/system/test_allocate_reserve_ids.py"
    "tests/system/test_query.py"
    "tests/system/test_put.py"
    "tests/system/test_read_consistency.py"
    "tests/system/test_transaction.py"
  ];

  pythonImportsCheck = [
    "google.cloud.datastore"
    "google.cloud.datastore_admin_v1"
    "google.cloud.datastore_v1"
  ];

  meta = {
    description = "Google Cloud Datastore API client library";
    homepage = "https://github.com/googleapis/python-datastore";
    changelog = "https://github.com/googleapis/python-datastore/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
