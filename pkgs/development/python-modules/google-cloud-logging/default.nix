{ lib
, buildPythonPackage
, django
, fetchPypi
, flask
, google-api-core
, google-cloud-appengine-logging
, google-cloud-audit-log
, google-cloud-core
, google-cloud-testutils
, grpc-google-iam-v1
, mock
, pandas
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, rich
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "3.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TeyxsL7UoOPA5Yo3ZkbmAC1r58rQOeNGaCLoZlBy6jM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    google-cloud-appengine-logging
    google-cloud-audit-log
    google-cloud-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    django
    flask
    google-cloud-testutils
    mock
    pandas
    pytestCheckHook
    pytest-asyncio
    rich
  ];

  preCheck = ''
    # Prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTests = [
    # Test requires credentials
    "test_write_log_entries"
    # No need for a second import check
    "test_namespace_package_compat"
  ];

  disabledTestPaths = [
    # Tests require credentials
    "tests/system/test_system.py"
    "tests/unit/test__gapic.py"
    # Exclude performance tests
    "tests/performance/test_performance.py"
  ];

  pythonImportsCheck = [
    "google.cloud.logging"
    "google.cloud.logging_v2"
  ];

  meta = with lib; {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/googleapis/python-logging";
    changelog = "https://github.com/googleapis/python-logging/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
