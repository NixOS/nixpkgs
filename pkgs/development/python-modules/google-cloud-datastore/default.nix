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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-datastore";
  version = "2.20.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_datastore";
    inherit version;
    hash = "sha256-lmXQCXKdlVEynZR29NW9qcEdNGkkPqiiwNlJC2WqiZ8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

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

  meta = with lib; {
    description = "Google Cloud Datastore API client library";
    homepage = "https://github.com/googleapis/python-datastore";
    changelog = "https://github.com/googleapis/python-datastore/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
